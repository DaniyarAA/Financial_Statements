<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta name="_csrf_token" content="${_csrf.token}">
    <title>Financial Statement</title>
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
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.14.1/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://code.jquery.com/ui/1.14.1/jquery-ui.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
</head>
<body>
<div class="container m-auto w-50">
    <div class="bg-success-subtle change-login-password-card card">
        <div class="card-header text-black bg-secondary-subtle">
            <h5 class="card-title">Изменение логина и пароля</h5>
        </div>
        <div class="card-body">
            <form id="changeLoginPasswordForm" method="post">
                <#if _csrf??>
                    <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                           value="${(_csrf.token)!'csrf-token'}"/>
                </#if>

                <div class="mb-3">
                    <label for="newUsername" class="form-label">Новый логин</label>
                    <input type="text" id="newUsername" name="newUsername" class="form-control"
                           placeholder="Введите новый логин" required>
                    <div id="loginErrorMessage" class="text-danger small mt-1"></div>
                </div>

                <div class="mb-3">
                    <label for="newPassword" class="form-label">Новый пароль</label>
                    <div class="input-group">
                        <input type="password" id="newPassword" name="newPassword" class="form-control"
                               placeholder="Введите новый пароль" required>
                        <button type="button" class="btn btn-outline-secondary" id="toggleNewPassword">
                            <i class="bi bi-eye-slash" id="newPasswordEyeIcon"></i>
                        </button>
                    </div>
                    <div id="passwordError" class="error-message"></div>
                </div>

                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">Подтвердите пароль</label>
                    <div class="input-group">
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                               placeholder="Повторите новый пароль" required>
                        <button type="button" class="btn btn-outline-secondary" id="toggleConfirmPassword">
                            <i class="bi bi-eye-slash" id="confirmPasswordEyeIcon"></i>
                        </button>
                    </div>
                    <div id="passwordErrorMessage" class="text-danger small mt-1"></div>
                </div>
            </form>
        </div>

        <div class="d-flex justify-content-center align-items-center modal-footer border-0">
            <button type="button" class="btn btn-success px-5"
                    title="Авторизоваться"
                    onclick="saveLoginAndPassword()">
                <i class="bi bi-check2"></i>
            </button>

            <#assign known = SPRING_SECURITY_CONTEXT??>
            <#if known>
                <#assign
                user = SPRING_SECURITY_CONTEXT.authentication.principal
                name = user.getUsername()>
                <#if _csrf??>
                    <form action="/logout" method="post">
                        <input type="hidden" name="${(_csrf.parameterName)!'csrf'}"
                               value="${(_csrf.token)!'--no-token--'}"/>
                        <button type="submit" class="btn btn-danger m-2 px-5" id="logout" title="Выход">
                            <i class="bi bi-x-lg"></i>
                        </button>
                    </form>
                <#else>
                    <a href="/logout" class="btn btn m-2" id="logout"
                       data-bs-toggle="tooltip" data-bs-placement="top" title="Выход">
                        <i class="bi bi-x-lg"></i>
                    </a>
                </#if>
            </#if>
        </div>
    </div>
</div>
<script src="/js/changeCredentials.js"></script>
</body>
</html>
