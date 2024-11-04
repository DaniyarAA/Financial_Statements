<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>
    <div class="login-container text-center">
        <p class="fs-3">Добро Пожаловать<#if username??>, ${username}</#if></p>
        <#if avatar??>
            <img src="/api/files/download/${avatar}" id="avatar" alt="avatar" class="profile-info-avatar-img">
        <#else >
            <img src="/user.png" class="login-info-avatar-img" alt="User Icon">
        </#if>
        <form id="login-form" action="/login" method="post">

            <!-- CSRF -->
            <#if _csrf??>
                <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                       value="${(_csrf.token)!'csrf-token'}"/>
            </#if>
            <div data-mdb-input-init class="form-outline mb-4 text-start">
                <label for="form2Example1">Логин:</label>
                <input type="text" id="form2Example1" class="form-control" name="username"/>
            </div>
            <div data-mdb-input-init class="form-outline mb-4 text-start">
                <label for="form2Example2">Пароль:</label>
                <input type="password" id="form2Example2" class="form-control" name="password"/>
            </div>
            <button type="submit" class="w-50">Войти</button>
        </form>
    </div>
</@layout.layout>
