<#import "/spring.ftl" as spring>
<#import "../layout.ftlh" as main>

<@main.layout>
    <div class="container-fluid mt-4">
        <div class="row">
            <!-- Sidebar for Company List -->
            <div class="col-md-3 col-lg-2 bg-light border-right">
                <h5 class="p-3">Компании</h5>
                <div class="list-group">
                    <#list companyDtos as company>
                        <a href="#" class="list-group-item list-group-item-action">
                            ${company.name}
                        </a>
                    </#list>
                </div>
            </div>

            <!-- Main Content Area -->
            <div class="col-md-9 col-lg-10">
                <h5>Задачи</h5>
                <div class="table-responsive">
                    <table class="table table-bordered">
                        <thead>
                        <tr>
                            <th scope="col">Месяц</th>
                            <#list companyDtos as company>
                                <th scope="col">${company.name}</th>
                            </#list>
                        </tr>
                        </thead>
                        <tbody>
                        <#list tasksByYearMonthAndCompany?keys as yearMonth>
                            <tr>
                                <td></td>
                                <#list companyDtos as company>
                                    <td>
                                        <#if tasksByYearMonthAndCompany[yearMonth]?? && tasksByYearMonthAndCompany[yearMonth][company.id]??>
                                            <#list tasksByYearMonthAndCompany[yearMonth][company.id] as task>
                                                <div class="task">
                                                    <span class="badge badge-pill badge-info">${task.company.name}</span>
                                                </div>
                                            </#list>
                                        <#else>
                                            No tasks
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
