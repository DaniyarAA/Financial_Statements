<#import "/spring.ftl" as spring>
<#import "../layout.ftlh" as main>

<@main.layout>
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
                                        <#if tasksByYearMonthAndCompany[yearMonth]?? && tasksByYearMonthAndCompany[yearMonth][company.id]??>
                                            <#list tasksByYearMonthAndCompany[yearMonth][company.id] as task>
                                                <div class="task">
                                                    <span class="badge badge-pill badge-info">${task.documentTypeName}</span>
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
</@main.layout>
