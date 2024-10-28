<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>
    <div class="login-container">
        <h2>Добро Пожаловать
            <#if username??>
                ${username}
            </#if>
        </h2>
        <#if avatar??>
            <img src="/api/files/download/${avatar}" id="avatar" alt="avatar" class="profile-info-avatar-img">
        <#else >
            <img src="/user.png" alt="User Icon">
        </#if>
        <form id="login-form" action="/login" method="post">

            <!-- CSRF -->
            <#if _csrf??>
                <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                       value="${(_csrf.token)!'csrf-token'}"/>
            </#if>
            <div data-mdb-input-init class="form-outline mb-4">
                <input type="text" id="form2Example1" class="form-control" name="username" placeholder="Login"/>
                <label class="form-label" for="form2Example1"></label>
            </div>
            <div data-mdb-input-init class="form-outline mb-4">
                <input type="password" id="form2Example2" class="form-control" name="password" placeholder="Password"/>
                <label class="form-label" for="form2Example2"></label>
            </div>
            <button type="submit">Войти</button>
        </form>
    </div>
</@layout.layout>
