<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>
    <div class="container-fluid p-3">
        <div class="row">
            <div class="col-md-12 mb-3 d-flex justify-content-between">
                <button id="prevPage" class="btn btn-secondary" <#if currentPage == 0>disabled</#if>
                        onclick="window.location.href='?page=${currentPage - 1}&size=7'">← Previous</button>
                <span>Page ${currentPage + 1} of ${totalPages}</span>
                <button id="nextPage" class="btn btn-secondary" <#if currentPage == totalPages - 1>disabled</#if>
                        onclick="window.location.href='?page=${currentPage + 1}&size=7'">Next →</button>
            </div>

            <div class="col-md-9">
                <div class="table-responsive">
                    <table class="table table-bordered text-center">
                        <thead class="thead-light">
                        <tr>
                            <th scope="col" class="font-weight-bold">Компании</th>
                            <#list monthsMap?keys as yearMonth>
                                <th scope="col" class="font-weight-bold">${monthsMap[yearMonth]}</th>
                            </#list>
                        </tr>
                        </thead>
                        <tbody>
                        <#list list as company>
                            <tr>
                                <td class="font-weight-bold">${company.name} ${company.id}</td>
                                <#list monthsMap?keys as yearMonth>
                                    <td>
                                        <#if tasksByYearMonthAndCompany[yearMonth]?? && tasksByYearMonthAndCompany[yearMonth][company.id?string]??>
                                            <div class="d-flex flex-row justify-content-center align-items-center flex-wrap">
                                                <#list tasksByYearMonthAndCompany[yearMonth][company.id?string] as task>
                                                    <button
                                                            class="btn btn-sm <#if task.isCompleted>btn-success<#else>btn-danger</#if> m-1"
                                                            onclick="showTaskDetails(this)"
                                                            data-task-id="${task.id}"
                                                            data-document-type="${task.documentTypeName}"
                                                            data-start-date="${task.startDateTime}"
                                                            data-company-name="${task.company.name}"
                                                            data-description="${task.description}"
                                                            data-amount="${task.amount}"
                                                            data-status="${task.statusId}">
                                                        ${task.documentTypeName}
                                                    </button>
                                                </#list>
                                            </div>
                                        <#else>
                                            <span class="text-muted font-italic">Нет задач</span>
                                        </#if>
                                    </td>
                                </#list>
                            </tr>
                        </#list>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="col-md-3">
                <div id="task-details" class="border p-3" style="display: none;">
                    <h5>Task Details</h5>
                    <div id="task-content"></div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="/js/tasks/list.js"></script>
</@layout.layout>
