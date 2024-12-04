<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>

    <section class="vh-100">
        <div class="container py-5 h-100">
            <div class="row justify-content-center align-items-center h-100">
                <div class="col-12 col-lg-9 col-xl-7">
                    <div class="card shadow-2-strong card-registration">
                        <div class="card-body p-4 p-md-5">
                            <h3 class="mb-4 pb-2 pb-md-0 mb-md-5">Регистрация нового пользователя</h3>
                            <form action="/admin/register" method="post" id="register-form">
                                <#if _csrf??>
                                    <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                                           value="${(_csrf.token)!'csrf-token'}"/>
                                </#if>

                                <div class="row">
                                    <div class="col-md-6 mb-4">

                                        <div data-mdb-input-init class="form-outline">
                                            <label for="name" class="form-label text-dark">Имя:</label>
                                            <@spring.formInput "userDto.name" 'id="name" class="form-control form-control-lg login-input"' />
                                        </div>
                                        <@spring.showErrors "<br>" "error text-danger mb-3" />

                                    </div>
                                    <div class="col-md-6 mb-4">

                                        <div data-mdb-input-init class="form-outline">
                                            <label for="surname" class="form-label text-dark">Фамилия:</label>
                                            <@spring.formInput "userDto.surname" 'id="surname" class="form-control form-control-lg login-input"' />
                                        </div>
                                        <@spring.showErrors "<br>" "error text-danger mb-3" />

                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-4">

                                        <div data-mdb-input-init class="form-outline w-100">
                                            <label for="login" class="form-label text">Логин:</label>
                                            <@spring.formInput "userDto.login" 'id="login" class="form-control form-control-lg login-input"' />
                                        </div>
                                        <@spring.showErrors "<br>" "error text-danger mb-3" />

                                    </div>

                                    <div class="col-md-6 mb-4 pb-2">

                                        <div data-mdb-input-init class="form-outline">
                                            <label for="password" class="form-label text-dark">Пароль:</label>
                                            <@spring.formPasswordInput "userDto.password" 'id="password" class="form-control form-control-lg login-input"' />
                                        </div>
                                        <@spring.showErrors "<br>" "error text-danger mb-3" />


                                    </div>
                                </div>


                                <div class="row">
                                    <div class="col-md-6 mb-4 pb-2">

                                        <div data-mdb-input-init class="form-outline">
                                            <label for="roleId" class="form-label text-dark">Роль:</label>
                                            <@spring.bind "userDto.roleDto.id"/>
                                            <select class="form-select form-select-lg login-input ${spring.status.error?string('is-invalid', '')}"
                                                    id="roleId" name="${spring.status.expression}">
                                                <option value="">Выберите роль для сотрудника</option>
                                                <#list roles as role>
                                                    <#if role?index != 0>
                                                        <option value="${role.id}" ${(spring.stringStatusValue == role.id?string)?string("selected", "")}>
                                                            ${role.roleName}
                                                        </option>
                                                    </#if>
                                                </#list>
                                            </select>

                                            <#if spring.status.error>
                                                <div class="invalid-feedback">
                                                    <#list spring.status.errorMessages as error>
                                                        ${error}<#if !error?is_last><br/></#if>
                                                    </#list>
                                                </div>
                                            </#if>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-4 pb-2">

                                        <div data-mdb-input-init class="form-outline w-100">
                                            <label for="email" class="form-label text">Электронная почта:</label>
                                            <@spring.formInput "userDto.email" 'id="email" class="form-control form-control-lg login-input"' />
                                        </div>
                                        <@spring.showErrors "<br>" "error text-danger mb-3" />
                                    </div>
                                </div>


                                <div class="row">
                                    <div class="col-md-6 mb-4">

                                        <div data-mdb-input-init class="form-outline">
                                            <label for="birthday" class="form-label">Дата рождения:</label>
                                            <input type="date" class="form-control form-control-lg login-input" id="birthday" name="birthday" required>
                                        </div>
                                        <#if error??>
                                            <b class="text-danger text-center mb-3">${error}</b>
                                        </#if>

                                    </div>



                                </div>


                            </form>


                        </div>

                    </div>
                    <div class="text-center">
                        <button type="submit" form="register-form" class="login-button fs-3">Создать пользователя</button>
                    </div>


                </div>

            </div>
        </div>
    </section>


</@layout.layout>