<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>

    <div class="user-form-container">
        <h2>Регистрация нового пользователя</h2>
        <form action="/admin/register" method="post" enctype="multipart/form-data">
            <#if _csrf??>
                <input type="hidden" name="${(_csrf.parameterName)!'csrf'}"
                       value="${(_csrf.token)!'--no-token--'}"/>
            </#if>

            <label for="name">Имя:</label>
            <@spring.formInput "userDto.name" 'id="form3Example3cg" class="form-control form-control-lg"' />
            <@spring.showErrors  "<br>" "error text-danger" />

            <label for="surname">Фамилия:</label>
            <@spring.formInput "userDto.surname" 'id="form3Example3cg" class="form-control form-control-lg"' />
            <@spring.showErrors  "<br>" "error text-danger" />

            <label for="login">Логин:</label>
            <@spring.formInput "userDto.login" 'id="form3Example3cg" class="form-control form-control-lg"' />
            <@spring.showErrors  "<br>" "error text-danger" />

            <label for="password">Пароль:</label>
            <@spring.formPasswordInput "userDto.password" 'id="form3Example3cg" class="form-control form-control-lg"' />
            <@spring.showErrors  "<br>" "error text-danger" />

            <label for="roleId">Роль:</label>
            <@spring.bind "userDto.roleDto.id"/>
            <select class="form-select ${spring.status.error?string('is-invalid', '')}"
                    id="roleId" name="${spring.status.expression}">
                <option value="">Выберите роль для сотрудника</option>
                <#list roles as role>
                    <#if role?index != 0>
                        <option value="${role.id}" ${(spring.stringStatusValue == role.id?string)?string("selected", "")}>
                            ${role.roleName}
                        </option>
                    </#if>
                </#list>
                <option value="create_new_role" data-bs-toggle="modal" data-bs-target="#createRoleModal">
                    Создать новую роль
                </option>
            </select>

            <#if spring.status.error>
                <div class="invalid-feedback">
                    <#list spring.status.errorMessages as error>
                        ${error}<#if !error?is_last><br/></#if>
                    </#list>
                </div>
            </#if>

            <label for="birthday">Дата рождения:</label>
            <input type="date" id="birthday" name="birthday" required>

            <#if error??>
                <b class="text-danger text-center mb-3">${error}</b>
            </#if>
            <button type="submit">Создать пользователя</button>
        </form>
    </div>


    <div class="modal fade" id="createRoleModal" tabindex="-1" aria-labelledby="createRoleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="createRoleModalLabel">Создание новой роли</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="createRoleForm" action="/admin/create/role" method="post">
                        <#if _csrf??>
                            <input type="hidden" name="${(_csrf.parameterName)!'csrf'}" value="${(_csrf.token)!'--no-token--'}"/>
                        </#if>
                        <div class="form-group mb-3">
                            <label for="roleName" class="form-label fw-semibold">Название роли:</label>
                            <input type="text" id="roleName" name="roleName" class="form-control" required>
                        </div>
                        <h3 class="h5 mb-3">Выберите права доступа:</h3>
                        <div class="row">
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_1" name="authorityIds" value="1" class="form-check-input">
                                    <label for="auth_1" class="form-check-label">Создание пользователя</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_2" name="authorityIds" value="2" class="form-check-input">
                                    <label for="auth_2" class="form-check-label">Удаление пользователя</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_3" name="authorityIds" value="3" class="form-check-input">
                                    <label for="auth_3" class="form-check-label">Редактирование пользователя</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_4" name="authorityIds" value="4" class="form-check-input">
                                    <label for="auth_4" class="form-check-label">Просмотр списка пользователей</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_4" name="authorityIds" value="5" class="form-check-input">
                                    <label for="auth_4" class="form-check-label">Создание задачи</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_4" name="authorityIds" value="6" class="form-check-input">
                                    <label for="auth_4" class="form-check-label">Удаление задачи</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_4" name="authorityIds" value="7" class="form-check-input">
                                    <label for="auth_4" class="form-check-label">Редактирование задачи</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_4" name="authorityIds" value="8" class="form-check-input">
                                    <label for="auth_4" class="form-check-label">Просмотр списка задач</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_4" name="authorityIds" value="9" class="form-check-input">
                                    <label for="auth_4" class="form-check-label">Создание компании</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_4" name="authorityIds" value="10" class="form-check-input">
                                    <label for="auth_4" class="form-check-label">Удаление компании</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_4" name="authorityIds" value="11" class="form-check-input">
                                    <label for="auth_4" class="form-check-label">Редактирование компании</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_4" name="authorityIds" value="12" class="form-check-input">
                                    <label for="auth_4" class="form-check-label">Просмотр списка компаний</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_4" name="authorityIds" value="13" class="form-check-input">
                                    <label for="auth_4" class="form-check-label">Создание новой роли</label>
                                </div>
                            </div>
                        </div>
                        <div class="text-center mt-4">
                            <button type="submit" class="btn btn-success">Создать</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="/js/users.js"></script>
</@layout.layout>