<#import '../layout.ftlh' as main>

<@main.layout ; spring>
    <div class="main-page">
        <div class="row row-cols-1 row-cols-lg-2 g-5">
            <div class="col">
                <div class="row row-cols-1 row-cols-md-2 g-1">
                    <div class="left col">
                        <div class="sidebar">
                            <a href="/report/create" class="button lock btn type-btn">СФОРМИРОВАТЬ ОТЧЕТ</a>
                            <a href="/tasks/create/everyMonth" class="button btn type-btn">ЕЖЕМЕСЯЧНЫЙ</a>
                            <a href="/tasks/create/everyQuarter" class="button btn type-btn">ЕЖЕКВАРТАЛЬНЫЙ</a>
                        </div>
                    </div>
                    <div class="left col">
                        <div class="center-column">
                            <a href="/company/add" class="button company btn type-btn mt-5">СОЗДАТЬ НОВЫЙ ИП/ОСОО</a>
                            <a href="/company/all?sort=actual" class="button company btn type-btn">СПИСОК КОМПАНИЙ</a>
                        </div>
                    </div>
                    <div class="left col">
                        <div class="archive">
                            <h3><a href="/archive/user" class="btn type-btn">АРХИВ</a></h3>
                            <ul>
                                <li>&bull;</li>
                                <li>&bull;</li>
                            </ul>
                        </div>
                    </div>
                    <div class="left col">
                            <div class="calendar-wrapper">
                                <h2 class="text-center">КАЛЕНДАРЬ</h2>
                                <div id="divCal"></div>
                            </div>
                    </div>
                </div>
            </div>
            <div class="col tasks">
                <div class="tasks-header">
                    <h3><a href="/tasks" class="btn type-submit">ЗАДАЧИ</a> </h3>
                    <a href="/tasks/create" class="btn type-btn add-task">
                        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" font-weight="bold"
                             fill="currentColor" class="bi bi-plus-circle" viewBox="0 0 16 16">
                            <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                            <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4"/>
                        </svg>
                    </a>
                </div>
                <div class="task-list">
                    <#if userDto.userCompanies ? has_content>
                        <#list userDto.userCompanies as company>
                            <div class="task-item mt-4">
                                <span>#${company.id} ${company.company.name}</span>
                                <div class="task-details">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                                         fill="currentColor" class="bi bi-calendar4" viewBox="0 0 16 16">
                                        <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5M2 2a1 1 0 0 0-1 1v1h14V3a1 1 0 0 0-1-1zm13 3H1v9a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1z"/>
                                    </svg>
                                    <span class="task-date">
                        <#if userDto.createdDate ? has_content>
                            ${userDto.createdDate?string("dd.MM.yyyy")}
                        <#else>55.55.5555
                        </#if>
                    </span>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor"
                                         class="bi bi-tag" viewBox="0 0 16 16">
                                        <path d="M6 4.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0m-1 0a.5.5 0 1 0-1 0 .5.5 0 0 0 1 0"/>
                                        <path d="M2 1h4.586a1 1 0 0 1 .707.293l7 7a1 1 0 0 1 0 1.414l-4.586 4.586a1 1 0 0 1-1.414 0l-7-7A1 1 0 0 1 1 6.586V2a1 1 0 0 1 1-1m0 5.586 7 7L13.586 9l-7-7H2z"/>
                                    </svg>
                                    <span class="task-tag pe-1">RSA...</span>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor"
                                         class="bi bi-caret-up me-3" viewBox="0 0 16 16">
                                        <path d="M3.204 11h9.592L8 5.519zm-.753-.659 4.796-5.48a1 1 0 0 1 1.506 0l4.796 5.48c.566.647.106 1.659-.753 1.659H3.204a1 1 0 0 1-.753-1.659"/>
                                    </svg>
                                    <div class="task-priority-bar"></div>
                                </div>
                            </div>
                        </#list>
                    <#else>
                        <span>Список компаний пуст</span>
                    </#if>
                </div>
            </div>
        </div>
    </div>
</@main.layout>