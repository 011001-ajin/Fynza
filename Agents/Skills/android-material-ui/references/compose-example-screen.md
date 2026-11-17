# Reference screen: all UI states in one pattern

A stateless screen showing Loading, Content, Empty, and Error states, token-only styling, a collapsing large top app bar, and one primary action. Copy the structure, not the content.

```kotlin
package com.example.app.ui.screens

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Add
import androidx.compose.material.icons.outlined.CloudOff
import androidx.compose.material.icons.outlined.Inbox
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.input.nestedscroll.nestedScroll
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.Preview
import com.example.app.R
import com.example.app.ui.theme.AppTheme

/*
 * Reference pattern: stateless screen with every state, token-only styling,
 * insets handled, one primary action. Copy the structure, not the content.
 */

data class Project(val id: String, val name: String, val subtitle: String)

sealed interface ProjectsUiState {
    data object Loading : ProjectsUiState
    data class Content(val items: List<Project>) : ProjectsUiState
    data object Empty : ProjectsUiState
    data class Error(val message: String) : ProjectsUiState
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ProjectsScreen(
    state: ProjectsUiState,
    onCreate: () -> Unit,
    onOpen: (Project) -> Unit,
    onRetry: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val scrollBehavior = TopAppBarDefaults.exitUntilCollapsedScrollBehavior()
    Scaffold(
        modifier = modifier.nestedScroll(scrollBehavior.nestedScrollConnection),
        topBar = {
            LargeTopAppBar(
                title = { Text(stringResource(R.string.projects_title)) },
                scrollBehavior = scrollBehavior,
            )
        },
        floatingActionButton = {
            if (state is ProjectsUiState.Content) {
                ExtendedFloatingActionButton(
                    onClick = onCreate,
                    icon = { Icon(Icons.Outlined.Add, contentDescription = null) },
                    text = { Text(stringResource(R.string.projects_create)) },
                )
            }
        },
    ) { innerPadding ->
        when (state) {
            ProjectsUiState.Loading -> Box(
                Modifier.fillMaxSize().padding(innerPadding),
                contentAlignment = Alignment.Center,
            ) { CircularProgressIndicator() }

            is ProjectsUiState.Content -> LazyColumn(
                contentPadding = PaddingValues(
                    top = innerPadding.calculateTopPadding(),
                    bottom = innerPadding.calculateBottomPadding() + AppTheme.spacing.fabClearance,
                ),
            ) {
                items(state.items, key = { it.id }) { project ->
                    ListItem(
                        headlineContent = { Text(project.name, maxLines = 1, overflow = TextOverflow.Ellipsis) },
                        supportingContent = { Text(project.subtitle, maxLines = 2, overflow = TextOverflow.Ellipsis) },
                        modifier = Modifier.clickable { onOpen(project) },
                    )
                }
            }

            ProjectsUiState.Empty -> MessageState(
                icon = { Icon(Icons.Outlined.Inbox, null, tint = MaterialTheme.colorScheme.onSurfaceVariant) },
                title = stringResource(R.string.projects_empty_title),
                body = stringResource(R.string.projects_empty_body),
                actionLabel = stringResource(R.string.projects_create),
                onAction = onCreate,
                modifier = Modifier.padding(innerPadding),
            )

            is ProjectsUiState.Error -> MessageState(
                icon = { Icon(Icons.Outlined.CloudOff, null, tint = MaterialTheme.colorScheme.onSurfaceVariant) },
                title = stringResource(R.string.error_title),
                body = state.message,
                actionLabel = stringResource(R.string.action_retry),
                onAction = onRetry,
                modifier = Modifier.padding(innerPadding),
            )
        }
    }
}

@Composable
private fun MessageState(
    icon: @Composable () -> Unit,
    title: String,
    body: String,
    actionLabel: String,
    onAction: () -> Unit,
    modifier: Modifier = Modifier,
) {
    Column(
        modifier = modifier
            .fillMaxSize()
            .padding(horizontal = AppTheme.spacing.lg),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center,
    ) {
        icon()
        Spacer(Modifier.height(AppTheme.spacing.md))
        Text(title, style = MaterialTheme.typography.titleMedium, textAlign = TextAlign.Center)
        Spacer(Modifier.height(AppTheme.spacing.xs))
        Text(
            body,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            textAlign = TextAlign.Center,
        )
        Spacer(Modifier.height(AppTheme.spacing.lg))
        Button(onClick = onAction) { Text(actionLabel) }
    }
}

@Preview(showBackground = true)
@Preview(showBackground = true, uiMode = android.content.res.Configuration.UI_MODE_NIGHT_YES)
@Preview(showBackground = true, fontScale = 1.5f)
@Composable
private fun ProjectsPreview() {
    AppTheme {
        ProjectsScreen(
            state = ProjectsUiState.Content(
                listOf(
                    Project("1", "Riverside renovation", "Updated 2 hours ago · 4 collaborators"),
                    Project("2", "Q4 budget review", "Updated yesterday · 2 collaborators"),
                )
            ),
            onCreate = {}, onOpen = {}, onRetry = {},
        )
    }
}
```

Strings used (add to `res/values/strings.xml`):

```xml
<string name="projects_title">Projects</string>
<string name="projects_create">New project</string>
<string name="projects_empty_title">No projects yet</string>
<string name="projects_empty_body">Create your first project to get started.</string>
<string name="error_title">Couldn't load projects</string>
<string name="action_retry">Try again</string>
```
