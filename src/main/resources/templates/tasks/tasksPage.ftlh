<#import "/spring.ftl" as spring>
<#import "../layout.ftlh" as main>

<@main.layout>
    <div class="container mt-5">
        <div class="text-center mb-4">
            <h2 class="mt-2">Таски жи есть</h2>
        </div>

        <div class="row">
            <div class="col-md-4">
                <form action="/tasks/test" method="get" class="form-inline" id="taskFilters">
                    <input type="hidden" name="page" id="page" value="${page}"/>
                    <input type="hidden" name="size" id="size" value="${size!9}"/>

                    <div class="form-group mx-sm-3 mb-2">
                        <label for="documentType" class="sr-only">Типы документов</label>
                        <select id="documentType" name="documentType" class="form-control">
                            <option value="">Все типы</option>
                            <#list documentTypeDto as doc>
                                <option value="${doc.id}">${doc.name}</option>
                            </#list>
                        </select>
                    </div>

                    <div class="form-group mx-sm-3 mb-2">
                        <label for="taskStatus" class="sr-only">Статусы</label>
                        <select id="taskStatus" name="taskStatus" class="form-control">
                            <option value="">Все статусы</option>
                            <#list taskStatusDtos as status>
                                <option value="${status.id}">${status.name}</option>
                            </#list>
                        </select>
                    </div>

                    <div class="form-group mx-sm-3 mb-2">
                        <button type="button" id="applyFiltersBtn" class="btn btn-success" onclick="this.form.submit()">
                            Сохранить фильтры
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div class="row" style="margin-top: 40px;">
            <#list taskDtos.content as task>
                <div class="col-md-4 mb-4">
                    <div class="card bg-light text-dark h-100">
                        <div class="card-body">
                            <h5 class="card-title">${task.user.name} ${task.user.surname}</h5>
                            <p class="card-text">${task.company.name}</p>
                            <p class="card-text">ИНН: ${task.company.inn}</p>
                            <p class="card-text">Тип документа: ${task.documentTypeName}</p>
                            <p class="card-text">От:
                                <#if task.startDate??>
                                    ${task.startDate}
                                <#else>
                                 Не указано
                                </#if>
                                 До:
                                <#if task.endDate??>
                                    ${task.endDate}

                                <#else>
                                    Не указано
                                </#if>
                            </p>
                            <p class="card-text">Сумма:
                                <#if task.amount??>
                                ${task.amount}
                                <#else>
                                    Не указано
                                </#if>
                            </p>
                            <#if task.description??>
                                <p class="card-text">Описание: ${task.getDescription()}</p>
                            </#if>
                        </div>
                    </div>
                </div>
            </#list>
        </div>

        <#if taskDtos.content?has_content>
            <div class="d-flex justify-content-center mt-4">
                <nav>
                    <ul class="pagination">
                        <#if taskDtos.hasPrevious()>
                            <li class="page-item">
                                <a class="page-link" href="?page=${taskDtos.number}<#if documentTypeId??>&documentType=${documentTypeId!""}</#if><#if taskStatusId??>&taskStatus=${taskStatusId!""}</#if>&size=${taskDtos.size}&sort=${sort}&direction=${direction}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </#if>

                        <#list 0..(taskDtos.totalPages - 1) as i>
                            <#if i == taskDtos.number>
                                <li class="page-item active">
                                    <span class="page-link">${i + 1}</span>
                                </li>
                            <#else>
                                <li class="page-item">
                                    <a class="page-link" href="?page=${i+1}<#if documentTypeId??>&documentType=${documentTypeId!""}</#if><#if taskStatusId??>&taskStatus=${taskStatusId!""}</#if>&size=${taskDtos.size}&sort=${sort}&direction=${direction}">${i + 1}</a>
                                </li>
                            </#if>
                        </#list>

                        <#if taskDtos.hasNext()>
                            <li class="page-item">
                                <a class="page-link" href="?page=${taskDtos.number + 2}<#if documentTypeId??>&documentType=${documentTypeId!""}</#if><#if taskStatusId??>&taskStatus=${taskStatusId!""}</#if>&size=${taskDtos.size}&sort=${sort}&direction=${direction}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </#if>
                    </ul>
                </nav>
            </div>
        <#else>
            <div class="d-flex justify-content-center mt-4">
                <p>Список пуст</p>
            </div>
        </#if>
    </div>
</@main.layout>