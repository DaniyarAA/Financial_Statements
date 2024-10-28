<#import "spring.ftl" as spring>
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
        <title>Document</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="/css/layout.css">

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@100..900&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
              crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
                crossorigin="anonymous"></script>
        <title>Financial Statement</title>
        <link rel="stylesheet" href="/static/css/styles.css">
    </head>
    <body>
    <nav class="navbar navbar-expand-lg navbar-light" style="background-color: #6DF700;">

        <div class="container-fluid">
            <a class="navbar-brand d-flex align-items-center" href="#">
                <span class="ms-2">Financial Statement</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link" href="/tasks">Таски</a>
                    </li>
                    <#assign known = SPRING_SECURITY_CONTEXT??>
                    <#if known>
                        <#assign
                        user = SPRING_SECURITY_CONTEXT.authentication.principal
                        name = user.username>
                    <#--                    <#list user.authorities as auth>-->
                    <#--                        <#if auth = "ADMIN">-->
                    <#--                            <li class="nav-item">-->
                    <#--                                <a class="nav-link active" aria-current="page" href="/admin/users">Пользователи</a>-->
                    <#--                            </li>-->
                    <#--                        </#if>-->
                    <#--                    </#list>-->
                        <#if _csrf??>
                            <li class="nav-item">
                                <a class="nav-link" href="/account">Профиль</a>
                            </li>
                            <form action="/logout" method="post">
                                <input type="hidden" name="${(_csrf.parameterName)!'csrf'}"
                                       value="${(_csrf.token)!'--no-token--'}"/>
                                <a class="btn btn-outline-light ms-3" href="/logout">Выйти</a>
                            </form>
                        <#else>

                        </#if>
                    <#else>

                        <li class="nav-item">
                            <a class="nav-link" href="/admin/register">Регистрация</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/companies">Компании</a>
                        </li>
                        <div class="d-flex align-items-center">
                            <a class="btn btn-outline-success ms-3" href="/login">Войти</a>
                        </div>
                    </#if>
                </ul>

                <div>

                </div>

            </div>
        </div>
    </nav>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>

    <main>
        <div class="container">
            <#nested spring >
        </div>
    </main>

    <#include "footer.ftlh" />

    </body>
    </html>

</#macro>