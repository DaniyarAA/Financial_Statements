<#import "/spring.ftl" as spring>
<#import "../layout.ftlh" as main>
<@main.layout>
    <div class="container py-5">
        <div class="card shadow-lg rounded">
            <div class="card-header bg-success text-white text-center">
                <h2>Создать таск</h2>
            </div>
            <div class="card-body">
                <form action="/tasks/create" method="post">
                    <#if _csrf??>
                        <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                               value="${(_csrf.token)!'csrf-token'}"/>
                    </#if>
                    <div class="mb-4">
                        <label for="category" class="form-label">Тип документа</label>
                        <select class="form-select" id="documentType" name="documentTypeId" required>
                            <#if documentTypeDtos??>
                                <#list documentTypeDtos as documentType>
                                    <option value="${documentType.id}">${documentType.name}</option>
                                </#list>
                            <#else>
                                <option disabled>Нет доступных типов документов</option>
                            </#if>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label for="category" class="form-label">Назначить</label>
                        <select class="form-select" id="user" name="appointToUserId" required>
                            <#if userDtos??>
                                <#list userDtos as user>
                                    <option value="${user.id}">${user.login}</option>
                                </#list>
                            <#else>
                                <option disabled>Нет доступных пользователей</option>
                            </#if>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label for="category" class="form-label">Компания</label>
                        <select class="form-select" id="company" name="companyId" required>
                            <#if companyDtos??>
                                <#list companyDtos as company>
                                    <option value="${company.id}">${company.name}</option>
                                </#list>
                            <#else>
                                <option disabled>Нет доступных компаний</option>
                            </#if>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label for="category" class="form-label">Статус</label>
                        <select class="form-select" id="taskStatus" name="taskStatusId" required>
                            <#if taskStatusDtos??>
                                <#list taskStatusDtos as taskStatus>
                                    <option value="${taskStatus.id}">${taskStatus.name}</option>
                                </#list>
                            <#else>
                                <option disabled>Нет доступных статусов</option>
                            </#if>
                        </select>
                    </div>

                    <div class="p-3 mb-4 border rounded bg-light">
                        <h5 class="mb-3">Выбор периода</h5>
                        <div class="mb-4">
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="reportType" id="weekly" value="weekly">
                                <label class="form-check-label" for="weekly">Недельный</label>
                            </div>

                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="reportType" id="decadal" value="decadal">
                                <label class="form-check-label" for="decadal">Декадный</label>
                            </div>

                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="reportType" id="monthly" value="monthly" checked>
                                <label class="form-check-label" for="monthly">Ежемесячный</label>
                            </div>

                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="reportType" id="quarterly" value="quarterly">
                                <label class="form-check-label" for="quarterly">Ежеквартальный</label>
                            </div>

                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="reportType" id="annual" value="annual">
                                <label class="form-check-label" for="annual">Годовой</label>
                            </div>
                        </div>

                        <div class="mb-3" id="weekSelection" style="display: none;">
                            <label for="week" class="form-label">Неделя</label>
                            <select class="form-select" id="week">
                                <option value="">Выберите неделю</option>
                                <option value="1">1 неделя</option>
                                <option value="2">2 неделя</option>
                                <option value="3">3 неделя</option>
                                <option value="4">4 неделя</option>
                            </select>
                        </div>

                        <div class="mb-3" id="decadeSelection" style="display:none;">
                            <label for="decade" class="form-label">Декада</label>
                            <select class="form-select" id="decade" name="decade">
                                <option value="">Выберите декаду</option>
                                <option value="1">1-я декада</option>
                                <option value="2">2-я декада</option>
                                <option value="3">3-я декада</option>
                            </select>
                        </div>

                        <div class="mb-3" id="monthSelection" style="display: none">
                            <label for="month" class="form-label">Месяц</label>
                            <select class="form-select" id="month" name="month">
                                <option value="">Выберите месяц</option>
                                <option value="1">Январь</option>
                                <option value="2">Февраль</option>
                                <option value="3">Март</option>
                                <option value="4">Апрель</option>
                                <option value="5">Май</option>
                                <option value="6">Июнь</option>
                                <option value="7">Июль</option>
                                <option value="8">Август</option>
                                <option value="9">Сентябрь</option>
                                <option value="10">Октябрь</option>
                                <option value="11">Ноябрь</option>
                                <option value="12">Декабрь</option>
                            </select>
                        </div>

                        <div class="mb-3" id="quarterSelection" style="display: none;">
                            <label for="quarter" class="form-label">Квартал</label>
                            <select class="form-select" id="quarter" name="quarter">
                                <option value="">Выберите квартал</option>
                                <option value="1">1 квартал</option>
                                <option value="2">2 квартал</option>
                                <option value="3">3 квартал</option>
                                <option value="4">4 квартал</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="year" class="form-label">Год</label>
                            <select class="form-select" id="year">
                                <option value="">Выберите год</option>
                                <option value="2023">2023</option>
                                <option value="2024">2024</option>
                                <option value="2025">2025</option>
                                <option value="2026">2026</option>
                                <option value="2027">2027</option>
                                <option value="2028">2028</option>
                                <option value="2029">2029</option>
                                <option value="2030">2030</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="startDate" class="form-label">Дата начала</label>
                            <input type="text" class="form-control" id="startDateDisplay" readonly>
                            <input type="hidden" id="startDate" name="startDate">
                        </div>

                        <div class="mb-3">
                            <label for="endDate" class="form-label">Дата окончания</label>
                            <input type="text" class="form-control" id="endDateDisplay" readonly>
                            <input type="hidden" id="endDate" name="endDate">
                        </div>

                    </div>

                    <div class="mb-4">
                        <label for="description" class="form-label">Описание</label>
                        <textarea class="form-control" id="description" name="description" rows="4" required></textarea>
                    </div>

                    <button type="submit" class="btn btn-success w-100">Создать</button>
                </form>
            </div>
        </div>
    </div>
    <script src="/js/taskDateLogic.js"></script>
</@main.layout>