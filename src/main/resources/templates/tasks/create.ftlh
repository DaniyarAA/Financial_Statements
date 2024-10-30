<#import "/spring.ftl" as spring>
<#import "../layout.ftlh" as main>

<@main.layout>
    <div class="container">
        <h1>Создать таск</h1>
        <form action="/tasks/create" method="post">
            <#if _csrf??>
                <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                       value="${(_csrf.token)!'csrf-token'}"/>
            </#if>
            <div class="mb-3">
                <label for="category" class="form-label">Тип документа</label>
                <select class="form-select" id="documentType" name="documentTypeId" required>
                    <#if documentTypeDtos??>
                        <#list documentTypeDtos as documentType>
                            <option value="${documentType.id}">${documentType.name}</option>
                        </#list>
                    <#else>
                        <option disabled>Нет доступных типов документов</option>
                    </#if>
                </select>
            </div>

            <div class="mb-3">
                <label for="category" class="form-label">Назначить</label>
                <select class="form-select" id="user" name="appointToUserId" required>
                    <#if userDtos??>
                        <#list userDtos as user>
                            <option value="${user.id}">${user.login}</option>
                        </#list>
                    <#else>
                        <option disabled>Нет доступных пользователей</option>
                    </#if>
                </select>
            </div>

            <div class="mb-3">
                <label for="category" class="form-label">Компания</label>
                <select class="form-select" id="company" name="companyId" required>
                    <#if companyDtos??>
                        <#list companyDtos as company>
                            <option value="${company.id}">${company.name}</option>
                        </#list>
                    <#else>
                        <option disabled>Нет доступных компаний</option>
                    </#if>
                </select>
            </div>

            <div class="mb-3">
                <label for="category" class="form-label">Статус</label>
                <select class="form-select" id="taskStatus" name="taskStatusId" required>
                    <#if taskStatusDtos??>
                        <#list taskStatusDtos as taskStatus>
                            <option value="${taskStatus.id}">${taskStatus.name}</option>
                        </#list>
                    <#else>
                        <option disabled>Нет доступных статусов</option>
                    </#if>
                </select>
            </div>

            <div class="mb-3">
                <label for="description" class="form-label">Описание</label>
                <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
            </div>

            <button type="submit" class="btn btn-primary">Создать</button>
        </form>
    </div>
</@main.layout>
