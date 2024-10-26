<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>

    <div class="user-form-container">
        <form action="/admin/user/edit/${editUserDto.id}" method="post" enctype="multipart/form-data">
            <#if _csrf??>
                <input type="hidden" name="${(_csrf.parameterName)!'csrf'}"
                       value="${(_csrf.token)!'--no-token--'}"/>
            </#if>
            <span class="delete-icon">🗑️</span>

            <h2>Редактирование пользователя: ${editUserDto.name} ${editUserDto.surname}</h2>
            <input type="file" name="avatar">

            <#--            <img src="${userDto.avatar?string('https://via.placeholder.com/80')}" alt="User Icon">TODO логика для фото юзера-->

            <label for="role">Роль:</label>
            <select id="role" name="roleId">
                <#list roles as role>
                    <option value="${role.id}">${role.roleName}</option>
                </#list>
            </select>

            <label for="name">login:</label>
            <@spring.formInput "editUserDto.login" 'id="form3Example3cg" class="form-control form-control-lg"' />
            <input type="date" id="birthdate" name="birthday" value="${editUserDto.birthday}">
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

            <#--            <label for="notes">Заметки:</label>-->
            <#--            <textarea id="notes" name="notes" rows="3" placeholder="Введите заметки">${userDto.notes}</textarea>-->

            <div class="icon-button">📁</div>

            <label for="notes">Заметки:</label>
            <textarea id="notes" rows="3" placeholder="Не добавляй больше 20 компаний под управление"></textarea>
            <button type="submit">Сохранить</button>
        </form>
    </div>
</@layout.layout>