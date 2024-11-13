<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>
    <div class="container p-3">
        <div class="row">
            <div class="col-md-12 mb-3">
                <button id="prevPage" onclick="window.location.href='?page=${currentPage - 1}&size=7'"
                        <#if currentPage == 0>disabled</#if> >← Previous</button>
                <span>Page ${currentPage + 1} of ${totalPages}</span>
                <button id="nextPage" onclick="window.location.href='?page=${currentPage + 1}&size=7'"
                        <#if currentPage == totalPages - 1>disabled</#if> >Next →</button>
            </div>

            <div class="col-md-9">
                <div class="table-responsive">
                    <table class="table-main">
                        <thead>
                        <tr>
                            <th class="company-column">Компании</th>
                            <#list monthsMap?keys as yearMonth>
                                <th>${monthsMap[yearMonth]}</th>
                            </#list>
                        </tr>
                        </thead>
                        <tbody>
                        <#list list as company>
                            <tr class="table-striped-row">
                                <td class="company-column">${company.name}</td>
                                <#list monthsMap?keys as yearMonth>
                                    <td>
                                        <#if tasksByYearMonthAndCompany[yearMonth]?? && tasksByYearMonthAndCompany[yearMonth][company.id?string]??>
                                            <div class="task-buttons">
                                                <#list tasksByYearMonthAndCompany[yearMonth][company.id?string] as task>
                                                    <button
                                                            class="<#if task.isCompleted>completed<#else>pending</#if>"
                                                            onclick="showTaskDetails(this)"
                                                            data-task-id="${task.id}"
                                                            data-document-type="${task.documentTypeName}"
                                                            data-start-date="${task.startDateTime}"
                                                            data-end-date="${task.endDateTime}"
                                                            data-company-inn="${task.company.inn}"
                                                            data-company-name="${task.company.name}"
                                                            data-description="${task.description}"
                                                            data-amount="${task.amount}"
                                                            data-status="${task.statusId}">
                                                        ${task.documentTypeName}
                                                    </button>
                                                </#list>
                                            </div>
                                        <#else>
                                            <span class="no-tasks">Нет задач</span>
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
                <div id="task-details" class="task-details">
                    <input type="hidden" id="csrfToken" value="${(_csrf.token)!'csrf-token'}"/>
                    <h5>Подробнее</h5>
                    <div id="task-content"></div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const taskStatusDtos = ${taskStatusDtosJson?no_esc};
    </script>
    <script src="/js/tasks/list.js"></script>

    <style>
        .table-main {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 3px;
            margin-bottom: 20px;
            box-shadow: -4px -4px 8px rgba(0, 0, 0, 0.2), 4px -4px 8px rgba(0, 0, 0, 0.2), 0px -4px 8px rgba(0, 0, 0, 0.2);
        }

        .table-main th, .table-main td {
            border: 3px solid #ffffff;
            padding: 15px;
            text-align: center;
            height: 70px;
        }

        .table-main tbody {
            background-color: #d9d9d9;
        }

        .company-column {
            width: 244px;
            text-align: center;
        }

        .table-striped-row:nth-child(odd) {
            background-color: #f5f5f5;
        }
        .table-striped-row:nth-child(even) {
            background-color: #d9d9d9;
        }

        /* Button styling */
        .task-buttons {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }
        .task-buttons button {
            margin: 4px;
            padding: 5px 10px;
            font-size: 12px;
        }
        .completed {
            background-color: #28a745;
            color: white;
        }
        .pending {
            background-color: #dc3545;
            color: white;
        }

        .task-details {
            padding: 15px;
            border: 1px solid #dee2e6;
        }

        .no-tasks {
            font-style: italic;
            color: #6c757d;
        }
    </style>




</@layout.layout>
