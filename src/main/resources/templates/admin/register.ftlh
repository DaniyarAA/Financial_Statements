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
                <@spring.bind "userDto.roleId"/>
                <select class="form-select ${spring.status.error?string('is-invalid', '')}"
                        id="roleId" name="${spring.status.expression}">
                    <option value="ROLE_ACCOUNTANT" ${(spring.stringStatusValue == "ROLE_ACCOUNTANT"?string)?string("selected", "")}>Бухгалтер</option>
                    <option value="ROLE_MANAGER" ${(spring.stringStatusValue == "ROLE_MANAGER"?string)?string("selected", "")}>Менеджер</option>
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

<#--            <label for="avatar">Аватар:</label>-->
<#--            <input type="file" id="avatar" name="avatar" accept="image/*">TODO логика для аватарки-->

            <label for="isActive">Активен:</label>
            <input type="checkbox" id="isActive" name="isActive" checked>

            <button type="submit">Создать пользователя</button>
        </form>
    </div>
</@layout.layout>