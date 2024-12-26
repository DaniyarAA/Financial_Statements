<#import 'spring.ftl' as spring>
<#macro layout>

    <!doctype html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport"
              content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <meta name="_csrf_header" content="${_csrf.headerName}">
        <meta name="_csrf_token" content="${_csrf.token}">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
        <link rel="stylesheet" href="/css/layout.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@100..900&display=swap" rel="stylesheet">
        <link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css'>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
              crossorigin="anonymous">
        <script src="/js/calendar.js"></script>
        <title>Financial Statement</title>
        <link rel="stylesheet" href="/css/styles.css">
        <link rel="stylesheet" href="https://code.jquery.com/ui/1.14.1/themes/base/jquery-ui.css">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://code.jquery.com/ui/1.14.1/jquery-ui.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
    </head>
    <body>
    <nav class="navbar navbar-expand-lg bg-body-tertiary">
        <div class="container-fluid">
            <div class="d-flex align-items-center">
                <a class="navbar-brand" href="/"><i class="bi bi-house-door"></i></a>

                <#assign known = SPRING_SECURITY_CONTEXT??>
                <#if known>
                    <#assign
                    user = SPRING_SECURITY_CONTEXT.authentication.principal
                    name = user.getUsername()>

                    <#list user.authorities as auth>
                        <#if auth=="VIEW_USER">
                            <a class="navbar-brand ms-2" href="/admin/users">
                                <i class="bi bi-people-fill"></i>
                            </a>
                        </#if>
                    </#list>
                </#if>
            </div>

            <div>
                <#if known>
                    <#if _csrf??>
                        <form action="/logout" method="post" class="d-inline">
                            <input type="hidden" name="${(_csrf.parameterName)!'csrf'}"
                                   value="${(_csrf.token)!'--no-token--'}"/>
                            <button type="submit" class="btn btn-dark m-2" id="logout">
                                Выйти
                            </button>
                        </form>
                    <#else>
                        <a href="/logout" class="btn btn m-2"
                           id="logout">Выйти</a>
                    </#if>
                </#if>
            </div>
        </div>
    </nav>


    <div class="container">

        <#nested spring>

    </div>

    </body>
    </html>

</#macro>