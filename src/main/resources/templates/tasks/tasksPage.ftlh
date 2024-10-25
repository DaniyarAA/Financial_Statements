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
                        <label for="category" class="sr-only">Типы документов</label>
                        <select id="category" name="category" class="form-control">
                            <option value="">Все типы</option>
                            <#list documentTypeDto as doc>
                                <option value="${doc.id}">${doc.name}</option>
                            </#list>
                        </select>
                    </div>

                    <div class="form-group mx-sm-3 mb-2">
                        <label for="category" class="sr-only">Статусы</label>
                        <select id="category" name="category" class="form-control">
                            <option value="">Все статусы</option>
                            <#list taskStatusDtos as status>
                                <option value="${status.id}">${status.name}</option>
                            </#list>
                        </select>
                    </div>

                    <div class="form-group mx-sm-3 mb-2">
                        <button type="button" id="applyFiltersBtn" class="btn btn-primary" onclick="this.form.submit()">
                            Сохранить фильтры
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div class="row" style="margin-top: 40px;">
            <#list taskDtos.content as task>
                <div class="col-md-4 mb-4">
                    <div class="card bg-dark text-white h-100">
                        <div class="card-body">
                            <h5 class="card-title">${task.user.getName()} ${task.user.getSurname()}</h5>
                            <p class="card-text">${task.get}</p>
                            <p class="card-text"><@spring.message 'vacancy.vacancies_main.responses'/>: ${v.quantityOfResponses}</p>
                            <p class="card-text"><@spring.message 'vacancy.vacancies_main.updated'/>: ${dateUtils.formatDateTime(v.updatedTime, "dd/MM/yyyy")}</p>
                            <a href="/vacancies/${v.id}" class="btn btn-outline-light w-100"><@spring.message 'vacancy.vacancies_main.more_info'/></a>
                        </div>
                    </div>
                </div>
            </#list>
        </div>

        <div class="d-flex justify-content-center mt-4">
            <nav>
                <ul class="pagination">
                    <#if vacancies.hasPrevious()>
                        <li class="page-item">
                            <a class="page-link" href="?page=${vacancies.number}&size=${vacancies.size}&sort=${sort}&direction=${direction}<#if categoryId??>&category=${categoryId!""}</#if>" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                    </#if>

                    <#list 0..(vacancies.totalPages - 1) as i>
                        <#if i == vacancies.number>
                            <li class="page-item active">
                                <span class="page-link">${i + 1}</span>
                            </li>
                        <#else>
                            <li class="page-item">
                                <a class="page-link" href="?page=${i+1}&size=${vacancies.size}&sort=${sort}&direction=${direction}<#if categoryId??>&category=${categoryId!""}</#if>">${i + 1}</a>
                            </li>
                        </#if>
                    </#list>

                    <#if vacancies.hasNext()>
                        <li class="page-item">
                            <a class="page-link" href="?page=${vacancies.number + 2}&size=${vacancies.size}&sort=${sort}&direction=${direction}<#if categoryId??>&category=${categoryId!""}</#if>" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </#if>
                </ul>
            </nav>
        </div>
    </div>
</@main.layout>