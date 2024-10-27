<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>

    <div class="user-form-container" xmlns="http://www.w3.org/1999/html">
        <form action="/admin/user/edit/${editUserDto.id}" method="post" enctype="multipart/form-data">
            <#if _csrf??>
                <input type="hidden" name="${(_csrf.parameterName)!'csrf'}"
                       value="${(_csrf.token)!'--no-token--'}"/>
            </#if>
            <span class="delete-icon" onclick="deleteUser(${editUserDto.id})">🗑️</span>

            <h2>Редактирование пользователя: ${editUserDto.name} ${editUserDto.surname}</h2>

            <label for="roleId">Роль:</label>
            <@spring.bind "editUserDto.roleDto.id"/>
            <select class="form-select ${spring.status.error?string('is-invalid', '')}"
                    id="roleId" name="${spring.status.expression}">
                <#list roles as role>
                    <#if role?index != 0>
                        <option value="${role.id}" <#if role.id == editUserDto.roleDto.id>selected</#if>>
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

            <label for="login">login:</label>
            <@spring.formInput "editUserDto.login" 'id="form3Example3cg" class="form-control form-control-lg"' />
            <@spring.showErrors  "<br>" "error text-danger" />

            <label for="name">Имя:</label>
            <@spring.formInput "editUserDto.name" 'id="form3Example3cg" class="form-control form-control-lg"' />
            <@spring.showErrors  "<br>" "error text-danger" />

            <label for="surname">Фамилия:</label>
            <@spring.formInput "editUserDto.surname" 'id="form3Example3cg" class="form-control form-control-lg"' />
            <@spring.showErrors  "<br>" "error text-danger" />

            <#--            <label for="contacts">Доступные компании:</label>-->
            <#--            <input type="text" id="contacts" name="contacts" value="${userDto.copanies}" placeholder="Введите контакты">TODO логика для списка компаний у юзера-->

            <label for="birthdate">Дата рождения:</label>
            <input type="date" id="birthdate" name="birthday" value="${editUserDto.birthday}">

            <input type="file" class="my-3" name="avatar">

            <div class="icon-button">📁</div>

            <label for="notes">Заметки:</label>
            <textarea id="notes" name="notes" rows="3"
                      <#if editUserDto.notes?has_content>
                          value="${editUserDto.notes}"
                      <#else>placeholder= "Добавьте заметки для пользователя" </#if>>

            </textarea>
            <button type="submit">Сохранить</button>
        </form>
    </div>

    <div class="modal fade" id="createRoleModal" tabindex="-1" aria-labelledby="createRoleModalLabel"
         aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="createRoleModalLabel">Создание новой роли</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="createRoleForm" action="/admin/create/role" method="post">
                        <#if _csrf??>
                            <input type="hidden" name="${(_csrf.parameterName)!'csrf'}"
                                   value="${(_csrf.token)!'--no-token--'}"/>
                        </#if>
                        <div class="form-group mb-3">
                            <label for="roleName" class="form-label fw-semibold">Название роли:</label>
                            <input type="text" id="roleName" name="roleName" class="form-control" required>
                        </div>
                        <h3 class="h5 mb-3">Выберите права доступа:</h3>
                        <div class="row">
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_1" name="authorityIds" value="1"
                                           class="form-check-input">
                                    <label for="auth_1" class="form-check-label">Создание пользователя</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_2" name="authorityIds" value="2"
                                           class="form-check-input">
                                    <label for="auth_2" class="form-check-label">Удаление пользователя</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_3" name="authorityIds" value="3"
                                           class="form-check-input">
                                    <label for="auth_3" class="form-check-label">Редактирование пользователя</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_4" name="authorityIds" value="4"
                                           class="form-check-input">
                                    <label for="auth_4" class="form-check-label">Просмотр списка пользователей</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_4" name="authorityIds" value="5"
                                           class="form-check-input">
                                    <label for="auth_4" class="form-check-label">Создание задачи</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_4" name="authorityIds" value="6"
                                           class="form-check-input">
                                    <label for="auth_4" class="form-check-label">Удаление задачи</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_4" name="authorityIds" value="7"
                                           class="form-check-input">
                                    <label for="auth_4" class="form-check-label">Редактирование задачи</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_4" name="authorityIds" value="8"
                                           class="form-check-input">
                                    <label for="auth_4" class="form-check-label">Просмотр списка задач</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_4" name="authorityIds" value="9"
                                           class="form-check-input">
                                    <label for="auth_4" class="form-check-label">Создание компании</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_4" name="authorityIds" value="10"
                                           class="form-check-input">
                                    <label for="auth_4" class="form-check-label">Удаление компании</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_4" name="authorityIds" value="11"
                                           class="form-check-input">
                                    <label for="auth_4" class="form-check-label">Редактирование компании</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_4" name="authorityIds" value="12"
                                           class="form-check-input">
                                    <label for="auth_4" class="form-check-label">Просмотр списка компаний</label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" id="auth_4" name="authorityIds" value="13"
                                           class="form-check-input">
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
    <script src="/static/js/script.js"></script>
</@layout.layout>