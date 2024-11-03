<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>
<div class="container-fluid mt-4">
    <div class="row">
        <div class="col-md-12">
            <h5>Задачи по компаниям и месяцам</h5>
            <div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                    <tr>
                        <th scope="col">Компании</th>
                        <#list monthsMap?keys as yearMonth>
                            <th scope="col">${monthsMap[yearMonth]}</th>
                        </#list>
                    </tr>
                    </thead>
                    <tbody>
                    <#list companyDtos as company>
                        <tr>
                            <td>${company.name} ${company.id}</td>
                            <#list monthsMap?keys as yearMonth>
                                <td>
                                    <#if tasksByYearMonthAndCompany[yearMonth]?? && tasksByYearMonthAndCompany[yearMonth][company.id?string]??>
                                        <#list tasksByYearMonthAndCompany[yearMonth][company.id?string] as task>
                                            <div class="task">
                                                    <span class="task-info">
                                                        ID:${task.id} Тип:${task.documentTypeName}
                                                    </span>
                                            </div>
                                        </#list>
                                    <#else>
                                        Нет задач
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
