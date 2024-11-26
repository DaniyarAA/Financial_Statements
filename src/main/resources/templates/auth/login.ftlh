<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>
    <div class="text-center">
        <div class="login-container">
            <p class="fs-3">Добро Пожаловать<#if username??>, ${username}</#if></p>
            <#if avatar??>
                <img src="/api/files/download/${avatar}" id="avatar" alt="avatar" class="profile-info-avatar-img">
            <#else >
                <img src="api/files/download/user.png" class="login-info-avatar-img" alt="User Icon">
            </#if>
            <form id="login-form" action="/login" method="post">

                <!-- CSRF -->
                <#if _csrf??>
                    <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                           value="${(_csrf.token)!'csrf-token'}"/>
                </#if>
                <span class="login-text"></span>
                <div data-mdb-input-init class="form-outline mb-4 text-start">
                    <label for="form2Example1">Логин:</label>
                    <input type="text" id="form2Example1" class="form-control login-input" name="username"/>
                </div>
                <div data-mdb-input-init class="form-outline mb-4 text-start position-relative">
                    <label for="form2Example2">Пароль:</label>
                    <input type="password" id="form2Example2" class="form-control login-input" name="password"/>
                    <i class="bi bi-star-fill"></i>
                </div>
            </form>
        </div>

        <button type="submit" form="login-form" class="login-button fs-3">Войти</button>
    </div>


    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>
    <script>
        let params = new URLSearchParams(window.location.search);
        if (params.has("error")) {
            window.onload = () => {
                let msg = $('.login-text')

                $(msg).text('Неверный login или пароль...')
                $(msg).addClass('text-danger');
                $(msg).removeClass('text-black-50');
            }
        }
    </script>
</@layout.layout>
