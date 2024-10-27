<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>
    <div class="container mt-5 justify-content-center align-items-center">
        <div class="card p-4 shadow-lg w-50 mx-auto">
            <h1 class="text-center mb-4">Создание новой роли</h1>
            <form action="/admin/create/role" method="post">
                <#if _csrf??>
                    <input type="hidden" name="${(_csrf.parameterName)!'csrf'}"
                           value="${(_csrf.token)!'--no-token--'}"/>
                </#if>

                <div class="form-group mb-3">
                    Название роли
                    <@spring.formInput "createRoleDto.roleName" 'id="form3Example3cg" class="form-control form-control-lg"' />
                    <@spring.showErrors  "<br>" "error text-danger" />
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
                <#if createRoleDto.authorityIds ? has_content>
                    <#else >
                        <span class="text-danger">
                            Выберите хотя бы одно полномочие
                        </span>
                </#if>
                <div class="text-center mt-4">
                    <button type="submit" class="btn btn-success">Создать</button>
                </div>
            </form>
        </div>
    </div>
</@layout.layout>
