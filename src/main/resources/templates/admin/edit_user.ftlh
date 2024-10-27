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

            <label for="contacts">Доступные компании:</label>


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
</@layout.layout>