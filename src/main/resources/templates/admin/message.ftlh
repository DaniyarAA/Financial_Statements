<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>

    <div class="container py-5 h-100">
        <div class="row d-flex align-items-center justify-content-center h-100">
            <div class="col-md-7 col-lg-5 col-xl-5 offset-xl-1">
                <#if error??>
                    <div class="alert alert-danger text-center" role="alert">
                        ${error}
                    </div>
                </#if>
                <#if message??>
                    <div class="alert alert-warning text-center" role="alert">
                        ${message}
                    </div>
                </#if>
                <form action="/admin/message" method="post">
                    <#if _csrf??>
                        <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                               value="${(_csrf.token)!'csrf-token'}"/>
                    </#if>
                    <div class="card border-secondary rounded p-3">
                        <div class="card-body">
                            <h5 class="card-title text-center">Пользователь создан успешно!</h5>
                            <p class="card-text">Сообщение для пользователя ${userDto.surname} ${userDto.name}:</p>
                            <p class="card-text fst-italic">"Здравствуйте, ${userDto.name}!</p>
                            <p class="card-text fst-italic">Ваш логин для входа в систему: ${userDto.login}</p>
                            <p class="card-text fst-italic">Ваш пароль для входа в систему: ${userDto.password}</p>
                            <p class="card-text fst-italic">Здесь будет ссылка на вход!"</p>
                            <p class="card-text ">Ниже вы можете дополнить сообщение для пользователя:</p>
                            <div class="mb-3">
                                <textarea name="adminText" id="adminText" class="form-control" rows="4"></textarea>
                            </div>
                            <input type="email" value="${userDto.email}" hidden="hidden" name="email">
                            <input type="text" value="${userDto.login}" hidden="hidden" name="login">
                            <input type="password" value="${userDto.password}" hidden="hidden" name="password">
                            <input type="text" value="${userDto.name}" name="userName" hidden="hidden">
                            <div class="text-center">
                                <button type="submit" class="btn btn-success btn-send-user-message">
                                    <i class="bi bi-check2 check-icon-send"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

</@layout.layout>
