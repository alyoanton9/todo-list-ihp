module Web.View.Tasks.Show where
import Web.View.Prelude

data ShowView = ShowView { task :: Task }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h5>Content</h5>
        <p>{task.content}</p>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Tasks" TasksAction
                            , breadcrumbText "Show Task"
                            ]