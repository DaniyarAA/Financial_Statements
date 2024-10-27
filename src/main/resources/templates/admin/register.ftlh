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

            <a type=" button btn-primary" href="/admin/create/role">Создать новую роль</a>
        </form>
    </div>

</@layout.layout>