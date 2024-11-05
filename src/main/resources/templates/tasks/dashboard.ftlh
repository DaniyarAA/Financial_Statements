<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>
    <div class="container-fluid p-3">
        <div class="row">
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
                        <#list companyDtos as company>
                            <tr>
                                <td class="font-weight-bold">${company.name} ${company.id}</td>
                                <#list monthsMap?keys as yearMonth>
                                    <td>
                                        <#if tasksByYearMonthAndCompany[yearMonth]?? && tasksByYearMonthAndCompany[yearMonth][company.id?string]??>
                                            <div class="d-flex flex-row justify-content-center align-items-center flex-wrap">
                                                <#list tasksByYearMonthAndCompany[yearMonth][company.id?string] as task>
                                                    <button
                                                            class="btn btn-sm <#if task.isCompleted>btn-success<#else>btn-danger</#if> m-1"
                                                            onclick="showTaskDetails(${task.id})">
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
                    <div id="task-content">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <script src="/js/tasks/dashboard"></script>
</@layout.layout>
