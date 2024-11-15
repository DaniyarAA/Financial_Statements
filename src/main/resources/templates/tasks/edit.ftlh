<#import '../layout.ftlh' as edit>
<@edit.layout; spring>
    <body>
    <div class="container mt-5">
        <h1 class="mb-4">Редактирование документа</h1>
        <form action="/tasks/edit" method="post">
            <input type="hidden" name="id" value="${taskDto.id}"/>
            <#if _csrf??>
                <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                       value="${(_csrf.token)!'csrf-token'}"/>
            </#if>
            <div class="mb-3">
                <label for="documentTypeName" class="form-label">Документ</label>
                <input type="text" class="form-control" id="documentTypeName" value="${taskDto.documentTypeName}"
                       readonly/>
            </div>

            <div class="mb-3">
                <label for="companyName" class="form-label">Компания:</label>
                <input type="text" class="form-control" id="companyName"
                       value="${taskDto.company.name} ИНН: ${taskDto.company.inn}" readonly/>
            </div>

            <div class="mb-3">
                <label for="startDateTime" class="form-label">Дата начала:</label>
                <input type="datetime-local" class="form-control" id="startDateTime" name="startDateTime"
                       value="${dateUtils.formatDateTime(taskDto.startDateTime, 'yyyy-MM-dd\'T\'HH:mm')}"/>

            </div>

            <div class="mb-3">
                <label for="endDateTime" class="form-label">Дата окончания:</label>
                <input type="datetime-local" class="form-control" id="endDateTime" name="endDateTime"
                       value="${dateUtils.formatDateTime(taskDto.endDateTime, 'yyyy-MM-dd\'T\'HH:mm')}"/>
            </div>

            <div class="mb-3">
                <label for="amount" class="form-label">Сумма:</label>
                <input type="number" class="form-control" id="amount" name="amount" step="0.01"
                       value="${taskDto.amount?if_exists}" />
            </div>

            <div class="mb-3">
                <label for="taskStatusId" class="form-label">Статус:</label>
                <select class="form-select" id="taskStatusId" name="statusId">
                    <#list taskStatusDtos as taskStatus>
                        <option value="${taskStatus.id}"
                                <#if taskStatus.id?string == taskDto.statusId?string>selected</#if>>${taskStatus.name}</option>
                    </#list>
                </select>
            </div>

            <div class="mb-3">
                <label for="description" class="form-label">Описание:</label>
                <textarea class="form-control" id="description" name="description">${taskDto.description}</textarea>
            </div>

            <div class="d-grid gap-2">
                <input type="submit" class="btn btn-primary" value="Сохранить"/>
            </div>
        </form>

        <#if !taskDto.isDeleted()>
            <div class="d-grid gap-2">
                <form action="/tasks/delete/${taskDto.id}" method="post">
                    <#if _csrf??>
                        <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                               value="${(_csrf.token)!'csrf-token'}"/>
                    </#if>
                    <input type="submit" class="btn btn-danger" value="Удалить отчет"/>
                </form>
            </div>
        <#else>
            <div class="alert alert-warning mt-3">
                Отчет был удален. Для восстановления обратитесь к администратору.
            </div>
        </#if>
    </div>
    </body>
</@edit.layout>