<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>
    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-3" style="background-color: #f8f8f8; padding: 0; overflow-y: auto; max-height: 80vh;">
                <h5 class="text-center mt-2">Компании</h5>
                <div class="list-group">
                    <#list companyDtos as company>
                        <button class="list-group-item list-group-item-action">
                            ${company.name} ${company.id}
                        </button>
                    </#list>
                </div>
            </div>

            <div class="col-9">
                <h5 class="text-center mt-2">Задачи по месяцам</h5>
                <div class="d-flex justify-content-between mb-2">
                    <button class="btn btn-light" id="prevMonthButton">&larr;</button>
                    <button class="btn btn-light" id="nextMonthButton">&rarr;</button>
                </div>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                        <tr>
                            <th scope="col">Месяц</th>
                            <#list monthsMap?keys as yearMonth>
                                <th scope="col" class="text-center">${monthsMap[yearMonth]}</th>
                            </#list>
                        </tr>
                        </thead>
                        <tbody>
                        <#list companyDtos as company>
                            <tr>
                                <td>${company.name}</td>
                                <#list monthsMap?keys as yearMonth>
                                    <td>
                                        <#if tasksByYearMonthAndCompany[yearMonth]?? && tasksByYearMonthAndCompany[yearMonth][company.id?string]??>
                                            <div class="d-flex flex-wrap justify-content-center">
                                                <#list tasksByYearMonthAndCompany[yearMonth][company.id?string] as task>
                                                    <div
                                                            class="task-box mx-1 my-1 p-1 text-center"
                                                            style="cursor: pointer; background-color: gray"
                                                            onclick="showTaskDetails(${task.id})">
                                                        ${task.documentTypeName}
                                                    </div>
                                                </#list>
                                            </div>
                                        <#else>
                                            <div class="text-muted text-center">Нет задач</div>
                                        </#if>
                                    </td>
                                </#list>
                            </tr>
                        </#list>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</@layout.layout>
