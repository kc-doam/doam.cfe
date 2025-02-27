﻿
#Область СлужебныеПроцедурыИФункции

// Возвращает настройки отправки.
// 
// Параметры:
// 	КлючНастроекОтправки - см. НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки
// Возвращаемое значение:
// 	- Неопределено - настройки не существуют
// 	- См. НастройкиЭДОКлиентСервер.НоваяНастройкаОтправки .
Функция НастройкиОтправки(КлючНастроекОтправки) Экспорт
	
	Если КлючНастроекОтправки = Неопределено Тогда
		Возврат КлючНастроекОтправки;
	КонецЕсли;
	
	Настройка = НастройкиЭДОКлиентСервер.НоваяНастройкаОтправки();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Отправитель,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Получатель,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Договор,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.ВидДокумента,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.ВерсияФормата КАК Формат,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.СпособОбменаЭД КАК СпособОбмена,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.ИдентификаторОтправителя,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.ИдентификаторПолучателя,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.ТребуетсяОтветнаяПодпись,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.ТребуетсяИзвещениеОПолучении,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.ВыгружатьДополнительныеСведения,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Формировать,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.ВерсияФорматаУстановленаВручную,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.ЗаполнениеКодаТовара,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.ОбменБезПодписи,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.МаршрутПодписания,
		|	ВЫБОР
		|		КОГДА НастройкиОтправкиЭлектронныхДокументовПоВидам.Договор = &Договор
		|			ТОГДА 0
		|		ИНАЧЕ 1
		|	КОНЕЦ КАК Порядок
		|ИЗ
		|	РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам КАК НастройкиОтправкиЭлектронныхДокументовПоВидам
		|ГДЕ
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Отправитель = &Отправитель
		|	И НастройкиОтправкиЭлектронныхДокументовПоВидам.Получатель = &Получатель
		|	И НастройкиОтправкиЭлектронныхДокументовПоВидам.ВидДокумента = &ВидДокумента
		|	И НастройкиОтправкиЭлектронныхДокументовПоВидам.Договор В (&Договор, &ПустойДоговор)
		|УПОРЯДОЧИТЬ ПО
		|	Порядок";
		
	Запрос.УстановитьПараметр("ВидДокумента", КлючНастроекОтправки.ВидДокумента);
	Запрос.УстановитьПараметр("Договор", КлючНастроекОтправки.Договор);
	Запрос.УстановитьПараметр("ПустойДоговор", Метаданные.ОпределяемыеТипы.ДоговорСКонтрагентомЭДО.Тип.ПривестиЗначение());
	Запрос.УстановитьПараметр("Отправитель", КлючНастроекОтправки.Отправитель);
	Запрос.УстановитьПараметр("Получатель", КлючНастроекОтправки.Получатель);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Настройка, ВыборкаДетальныеЗаписи);
		КлючПриглашенияНаИдентификатор = ПриглашенияЭДОКлиентСервер.КлючПриглашенияНаИдентификатор();
		КлючПриглашенияНаИдентификатор.ИдентификаторОрганизации = Настройка.ИдентификаторОтправителя;
		КлючПриглашенияНаИдентификатор.ИдентификаторКонтрагента = Настройка.ИдентификаторПолучателя;

		КлючПриглашения = ПриглашенияЭДОКлиентСервер.НовыйКлючПриглашения();
		КлючПриглашения.Ключ = ПриглашенияЭДО.КлючПриглашенияПоНатуральнымКлючам(КлючПриглашенияНаИдентификатор);
		КлючПриглашения.ИдентификаторОрганизации = Настройка.ИдентификаторОтправителя;

		ДанныеПриглашения = ПриглашенияЭДО.ДанныеПриглашения(КлючПриглашения);
		Если ДанныеПриглашения = Неопределено Тогда
			СтатусПриглашения = Неопределено;
		Иначе
			СтатусПриглашения = ДанныеПриглашения.Статус;
		КонецЕсли;
		Настройка.ГотовностьКОбмену = ПриглашенияЭДО.ПриглашениеПринято(СтатусПриглашения)
			Или ПриглашенияЭДО.ОжидаетсяОтветНаПриглашение(СтатусПриглашения);
	КонецЦикла;
	
	Возврат Настройка;
	
КонецФункции

// Изменяет настройку отправки электронных документов.
// 
// Параметры:
// 	Настройка - см. НастройкиЭДОКлиентСервер.НоваяНастройкаОтправки
Процедура ИзменитьНастройку(Настройка) Экспорт
	
	Менеджер = РегистрыСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Менеджер, Настройка, "Отправитель, Получатель, Договор, ВидДокумента");
	Менеджер.Прочитать();

	Свойства = "ИдентификаторОтправителя, ИдентификаторПолучателя,
	|МаршрутПодписания, ТребуетсяОтветнаяПодпись, ТребуетсяИзвещениеОПолучении, ВыгружатьДополнительныеСведения,
	|ВерсияФорматаУстановленаВручную, ЗаполнениеКодаТовара";
	МассивСвойств = СтрРазделить(Свойства, ",");
	Для Каждого Свойство Из МассивСвойств Цикл
		ИмяСвойства = СокрЛП(Свойство);
		ЗначениеСвойства = Настройка[ИмяСвойства];
		Если ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			Менеджер[ИмяСвойства] = ЗначениеСвойства;
		КонецЕсли;
	КонецЦикла;
	Если ЗначениеЗаполнено(Настройка.Формат) Тогда
		Менеджер.ВерсияФормата = Настройка.Формат;
	КонецЕсли;
	
	Менеджер.Записать();
	
КонецПроцедуры

Функция ЭтоРасширеннаяНастройка(КлючНастроекОтправки) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.ИдентификаторОтправителя КАК ИдентификаторОтправителя,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.ИдентификаторПолучателя КАК ИдентификаторПолучателя
		|ИЗ
		|	РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам КАК НастройкиОтправкиЭлектронныхДокументовПоВидам
		|ГДЕ
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Отправитель = &Отправитель
		|	И НастройкиОтправкиЭлектронныхДокументовПоВидам.Получатель = &Получатель
		|	И НастройкиОтправкиЭлектронныхДокументовПоВидам.Договор = &Договор";
	
	Запрос.УстановитьПараметр("Отправитель", КлючНастроекОтправки.Отправитель);
	Запрос.УстановитьПараметр("Получатель", КлючНастроекОтправки.Получатель);
	Запрос.УстановитьПараметр("Договор", КлючНастроекОтправки.Договор);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Возврат ВыборкаДетальныеЗаписи.Количество() > 1;
	
КонецФункции

Процедура ИзменитьТранспортныеНастройки(КлючНастроекОтправки, ИдентификаторОтправителя,
	ИдентификаторПолучателя) Экспорт
	
	НаборЗаписей = РегистрыСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Отправитель.Установить(КлючНастроекОтправки.Отправитель);
	НаборЗаписей.Отбор.Получатель.Установить(КлючНастроекОтправки.Получатель);
	НаборЗаписей.Отбор.Договор.Установить(КлючНастроекОтправки.Договор);
	
	НачатьТранзакцию();
	Попытка
		
		ОбщегоНазначенияБЭД.УстановитьУправляемуюБлокировкуПоНаборуЗаписей(НаборЗаписей);
		НаборЗаписей.Прочитать();
		Таблица = НаборЗаписей.Выгрузить();
		Таблица.ЗаполнитьЗначения(ИдентификаторОтправителя, "ИдентификаторОтправителя");
		Таблица.ЗаполнитьЗначения(ИдентификаторПолучателя, "ИдентификаторПолучателя");
		НаборЗаписей.Загрузить(Таблица);
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Изменение настроек отправки ЭДО'"),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

Функция ИспользуетсяУПД_УКД(КлючНастроекОтправки) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользуетсяУПД", Ложь);
	Результат.Вставить("ИспользуетсяУКД", Ложь);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	НастройкиОтправкиЭлектронныхДокументов.ИспользоватьУПД КАК ИспользуетсяУПД,
		|	НастройкиОтправкиЭлектронныхДокументов.ИспользоватьУКД КАК ИспользуетсяУКД,
		|	ВЫБОР
		|		КОГДА НастройкиОтправкиЭлектронныхДокументов.Договор = &Договор
		|			ТОГДА 0
		|		КОГДА НастройкиОтправкиЭлектронныхДокументов.Договор = &ПустойДоговор
		|			ТОГДА 1
		|		ИНАЧЕ 2
		|	КОНЕЦ КАК Порядок
		|ИЗ
		|	РегистрСведений.НастройкиОтправкиЭлектронныхДокументов КАК НастройкиОтправкиЭлектронныхДокументов
		|ГДЕ
		|	НастройкиОтправкиЭлектронныхДокументов.Отправитель = &Отправитель
		|	И НастройкиОтправкиЭлектронныхДокументов.Получатель = &Получатель
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок";
	
	Запрос.УстановитьПараметр("Договор", КлючНастроекОтправки.Договор);
	Запрос.УстановитьПараметр("ПустойДоговор", Метаданные.ОпределяемыеТипы.ДоговорСКонтрагентомЭДО.Тип.ПривестиЗначение());
	Запрос.УстановитьПараметр("Отправитель", КлючНастроекОтправки.Отправитель);
	Запрос.УстановитьПараметр("Получатель", КлючНастроекОтправки.Получатель);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Результат, ВыборкаДетальныеЗаписи);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция НоваяТаблицаНастроек() Экспорт
	
	Настройки = Новый ТаблицаЗначений;
	МетаданныеРегистра = РегистрыСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.СоздатьНаборЗаписей().Метаданные();
	
	Для каждого Измерение Из МетаданныеРегистра.Измерения Цикл
		Настройки.Колонки.Добавить(Измерение.Имя, Измерение.Тип);
	КонецЦикла; 
	
	Для каждого Ресурс Из МетаданныеРегистра.Ресурсы Цикл
		Настройки.Колонки.Добавить(Ресурс.Имя, Ресурс.Тип);
	КонецЦикла;
	
	Для каждого Реквизит Из МетаданныеРегистра.Реквизиты Цикл
		Настройки.Колонки.Добавить(Реквизит.Имя, Реквизит.Тип);
	КонецЦикла;
	
	Настройки.Колонки.Добавить("Приоритет", Новый ОписаниеТипов("Число"));
	Настройки.Колонки.Добавить("Группа", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(100)));
	Настройки.Колонки.Добавить("ПриоритетГруппы", Новый ОписаниеТипов("Число"));
	Настройки.Колонки.Добавить("ДокументУчета", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(100)));
	Настройки.Колонки.Добавить("ДополнительныеНастройки", Новый ОписаниеТипов("Строка"));
	
	Возврат Настройки;
	
КонецФункции

// Возвращает представление настройки отправки.
// 
// Параметры:
// 	КлючНастройки - РегистрСведенийКлючЗаписи.НастройкиОтправкиЭлектронныхДокументов
// Возвращаемое значение:
// 	Строка - Описание
Функция ПредставлениеНастройкиОтправки(КлючНастройки) Экспорт

	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить(КлючНастройки.Получатель);
	МассивСтрок.Добавить(КлючНастройки.Отправитель);
	Если ЗначениеЗаполнено(КлючНастройки.Договор) Тогда
		МассивСтрок.Добавить(КлючНастройки.Договор);
	КонецЕсли;
	
	Возврат СтрСоединить(МассивСтрок, " • ");

КонецФункции

Функция СсылкаНаОбъектНастройкиЭДО(Организация, Контрагент, ДоговорКонтрагента) Экспорт
	
	Результат = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	НастройкиЭДО.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.НастройкиЭДО КАК НастройкиЭДО
		|ГДЕ
		|	НастройкиЭДО.Организация = &Организация
		|	И НастройкиЭДО.Контрагент = &Контрагент
		|	И НастройкиЭДО.ДоговорКонтрагента = &ДоговорКонтрагента";
	
	Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	ПоляБлокировки = Новый Структура;
	ПоляБлокировки.Вставить("Организация", Организация);
	ПоляБлокировки.Вставить("Контрагент", Контрагент);
	ПоляБлокировки.Вставить("ДоговорКонтрагента", ДоговорКонтрагента);
		
	НачатьТранзакцию();
	Попытка
		ОбщегоНазначенияБЭД.УстановитьУправляемуюБлокировку("Справочник.НастройкиЭДО", ПоляБлокировки);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			Результат = ВыборкаДетальныеЗаписи.Ссылка;
		Иначе
			НовыйЭлемент = Справочники.НастройкиЭДО.СоздатьЭлемент();
			НовыйЭлемент.Организация        = Организация;
			НовыйЭлемент.Контрагент         = Контрагент;
			НовыйЭлемент.ДоговорКонтрагента = ДоговорКонтрагента;
			НовыйЭлемент.Записать();
			Результат = НовыйЭлемент.Ссылка;
		КонецЕсли;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВидОперации = НСтр("ru = 'Поиск ссылки на настройку электронного документооборота'",
			ОбщегоНазначения.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(ВидОперации, УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
		
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьСписокУчетныхЗаписейПрямогоОбмена(Список, Организация = Неопределено) Экспорт
	
	Запросы = Новый Массив;
	
	ОтборУчетныхЗаписей = СинхронизацияЭДО.НовыйОтборУчетныхЗаписей();
	ОтборУчетныхЗаписей.СпособОбмена = "&СпособОбмена";
	Если Организация <> Неопределено Тогда
		ОтборУчетныхЗаписей.Организация = "&Организация";
	КонецЕсли;
	ЗапросУчетныхЗаписей = СинхронизацияЭДО.ЗапросУчетныхЗаписей("УчетныеЗаписиЭДО", ОтборУчетныхЗаписей);
	Запросы.Добавить(ЗапросУчетныхЗаписей);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	УчетныеЗаписиЭДО.ИдентификаторЭДО,
		|	УчетныеЗаписиЭДО.НаименованиеУчетнойЗаписи
		|ИЗ
		|	УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО";
	
	ИтоговыйЗапрос = ОбщегоНазначенияБЭД.СоединитьЗапросы(Запрос, Запросы);
	ИтоговыйЗапрос.УстановитьПараметр("Организация", Организация);
	ИтоговыйЗапрос.УстановитьПараметр("СпособОбмена", СинхронизацияЭДО.СпособыПрямогоОбмена());
	РезультатЗапроса = ИтоговыйЗапрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Список.Добавить(ВыборкаДетальныеЗаписи.ИдентификаторЭДО, ВыборкаДетальныеЗаписи.НаименованиеУчетнойЗаписи);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьНастройкиПоВидамЭлектронныхДокументов(Настройки, ВидыДокументов, СпособОбмена = Неопределено) Экспорт
	
	ШаблоныНастроекПоВидам = ЭлектронныеДокументыЭДО.ШаблоныНастроекОтправкиВидовДокументов(ВидыДокументов);
	
	Для Каждого ШаблонНастройки Из ШаблоныНастроекПоВидам Цикл
		Настройка = Настройки.Добавить();
		ЗаполнитьЗначенияСвойств(Настройка, ШаблонНастройки);
		Настройка.ВерсияФормата = ШаблонНастройки.Формат;
		Настройка.Формировать = Истина;
		Если СпособОбмена <> Неопределено Тогда
			Настройка.СпособОбменаЭД = СпособОбмена;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьНастройкиПоВидамЭлектронныхДокументовИнтеркампани(Настройки, ВидыДокументов, Отправитель,
	Получатель) Экспорт
	
	ОтборФорматов = ЭлектронныеДокументыЭДО.НовыйОтборФорматовЭлектронныхДокументов();
	ОтборФорматов.ВидыДокументов = ВидыДокументов;
	ОтборФорматов.Действует = Истина;
	Форматы = ЭлектронныеДокументыЭДО.ФорматыЭлектронныхДокументов(ОтборФорматов);
	
	УпорядоченныеВидыДокументов = Новый Массив;
	ПервыйВидДокумента = ЭлектронныеДокументыЭДО.ВидДокументаПоТипу(
		Перечисления.ТипыДокументовЭДО.ПередачаТоваровМеждуОрганизациями);
	ИндексЭлемента = ВидыДокументов.Найти(ПервыйВидДокумента);
	Если ИндексЭлемента <> Неопределено Тогда
		УпорядоченныеВидыДокументов.Добавить(ПервыйВидДокумента);
	КонецЕсли;
	Для Каждого ВидДокумента Из ВидыДокументов Цикл
		Если ВидДокумента <> ПервыйВидДокумента Тогда
			УпорядоченныеВидыДокументов.Добавить(ВидДокумента);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ВидДокумента Из УпорядоченныеВидыДокументов Цикл
		НоваяСтрока = Настройки.Добавить();
		НоваяСтрока.Отправитель              = Отправитель;
		НоваяСтрока.Получатель               = Получатель;
		НоваяСтрока.ВидДокумента             = ВидДокумента;
		НоваяСтрока.МаршрутПодписания        = МаршрутыПодписанияБЭД.МаршрутОднойДоступнойПодписью();
		НоваяСтрока.СпособОбменаЭД           = Перечисления.СпособыОбменаЭД.Внутренний;
		НоваяСтрока.Формировать              = Истина;
		
		ИдентификаторФормата = "";
		СведенияОФормате = Форматы.Найти(ВидДокумента, "ВидДокумента");
		Если СведенияОФормате <> Неопределено Тогда
			ИдентификаторФормата = СведенияОФормате.ИдентификаторФормата;
		КонецЕсли;
		НоваяСтрока.ВерсияФормата = ИдентификаторФормата;
	КонецЦикла;
	
КонецПроцедуры

Функция ЗаписатьНастройкиИнтеркампани(Настройки, Отправитель, Получатель) Экспорт
	
	Настройки.ЗаполнитьЗначения(Отправитель, "Отправитель");
	Настройки.ЗаполнитьЗначения(Получатель , "Получатель");
	
	ИдентификаторыОрганизацийИнтеркампани = НастройкиОтправкиЭДОСлужебный.ИдентификаторыОрганизацийИнтеркампани(
		Отправитель, Получатель);
		
	Настройки.ЗаполнитьЗначения(ИдентификаторыОрганизацийИнтеркампани.ИдентификаторОтправителя,
		"ИдентификаторОтправителя");
	Настройки.ЗаполнитьЗначения(ИдентификаторыОрганизацийИнтеркампани.ИдентификаторПолучателя,
		"ИдентификаторПолучателя");
	
	НачатьТранзакцию();
	Попытка
		
		Для Каждого СтрокаТЧ Из Настройки Цикл
			
			МенеджерЗаписи = РегистрыСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, СтрокаТЧ);
			МенеджерЗаписи.Записать();
			
		КонецЦикла;
		
	ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ВидОперации = НСтр("ru = 'Сохранение настроек отправки между своими организациями ЭДО'");
		
		ЭлектронноеВзаимодействие.ОбработатьОшибку(ВидОперации, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке),
			НСтр("ru = 'Не удалось сохранить Настройки между своими организациями
                  |Подробнее см. в журнале регистрации.'"));
			
		Возврат Ложь;
		
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция ИдентификаторыОрганизацийИнтеркампани(Отправитель, Получатель) Экспорт
	
	ИмяРеквизитаИННОрганизации = ИнтеграцияЭДО.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("ИННОрганизации");
	ИмяРеквизитаКППОрганизации = ИнтеграцияЭДО.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("КППОрганизации");
	
	МассивОрганизаций = Новый Массив;
	МассивОрганизаций.Добавить(Отправитель);
	МассивОрганизаций.Добавить(Получатель);
	
	ПараметрыОрганизаций = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МассивОрганизаций,
		ИмяРеквизитаИННОрганизации + ", " + ИмяРеквизитаКППОрганизации);
		
	ИдентификаторОтправителя = ИдентификаторОрганизацииИнтеркампани(
		ПараметрыОрганизаций.Получить(Отправитель), ИмяРеквизитаИННОрганизации, ИмяРеквизитаКППОрганизации);
				
	ИдентификаторПолучателя = ИдентификаторОрганизацииИнтеркампани(
		ПараметрыОрганизаций.Получить(Получатель), ИмяРеквизитаИННОрганизации, ИмяРеквизитаКППОрганизации);
	
	Идентификаторы = Новый Структура;
	Идентификаторы.Вставить("ИдентификаторОтправителя", ИдентификаторОтправителя);
	Идентификаторы.Вставить("ИдентификаторПолучателя", ИдентификаторПолучателя);
	
	Возврат Идентификаторы;
	
КонецФункции

Процедура ЗаполнитьТаблицуФормыНастроекОтправки(ТаблицаФормы, Настройки) Экспорт
	
	Настройки.Сортировать("ПриоритетГруппы, Приоритет");
	
	ТекущаяГруппа = "";
	Для Каждого СтрокаТаблицы Из Настройки Цикл
		Если СтрокаТаблицы.Группа <> ТекущаяГруппа Тогда
			НоваяСтрока = ТаблицаФормы.Добавить();
			НоваяСтрока.ЭтоГруппа = Истина;
			НоваяСтрока.ДокументУчета = СтрокаТаблицы.Группа;
			ТекущаяГруппа = СтрокаТаблицы.Группа;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ТаблицаФормы.Добавить(), СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьУсловноеОформлениеДляГруппировкиНастроек(УсловноеОформление, СкрываемыеПоля) Экспорт
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИсходящиеДокументы.ЭтоГруппа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ИсходящиеДокументыДокументУчета");
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИсходящиеДокументы.ЭтоГруппа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ИсходящиеДокументыДокументУчета");
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИсходящиеДокументы.ЭтоГруппа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Для Каждого СкрываемоеПоле Из СкрываемыеПоля Цикл
		ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(СкрываемоеПоле);
	КонецЦикла;
	
КонецПроцедуры

// Проверяет соответствие сертификатов маршрутам в настройке.
// 
// Параметры:
// 	ПроверяемаяНастройка - см. НовоеОписаниеПроверяемойНастройки
// 	КонтекстДиагностики - см. ОбработкаНеисправностейБЭД.
// Возвращаемое значение:
// 	Булево
Функция СертификатыСоответствуютМаршрутам(ПроверяемаяНастройка, КонтекстДиагностики) Экспорт
	
	НаборыСертификатовУчетныхЗаписей = Новый Соответствие;
	
	Запросы = Новый Массив;
	
	Отбор = СинхронизацияЭДО.НовыйОтборСертификатовУчетныхЗаписей();
	Отбор.УчетныеЗаписи = "&УчетныеЗаписи";
	
	ЗапросСертификатовУчетныхЗаписей = СинхронизацияЭДО.ЗапросСертификатовУчетныхЗаписей("СертификатыУчетныхЗаписейЭДО",
		Отбор);
	Запросы.Добавить(ЗапросСертификатовУчетныхЗаписей);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СертификатыУчетныхЗаписейЭДО.ИдентификаторЭДО КАК УчетнаяЗапись,
	|	СертификатыУчетныхЗаписейЭДО.Сертификат КАК Сертификат
	|ИЗ
	|	СертификатыУчетныхЗаписейЭДО КАК СертификатыУчетныхЗаписейЭДО
	|
	|УПОРЯДОЧИТЬ ПО
	|	УчетнаяЗапись,
	|	Сертификат
	|ИТОГИ ПО
	|	УчетнаяЗапись";
	
	ИтоговыйЗапрос = ОбщегоНазначенияБЭД.СоединитьЗапросы(Запрос, Запросы);
	
	ИтоговыйЗапрос.УстановитьПараметр("УчетныеЗаписи", ПроверяемаяНастройка.ИдентификаторыОтправителя);
	УстановитьПривилегированныйРежим(Истина);
	ВыборкаУчетныхЗаписей = ИтоговыйЗапрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	УстановитьПривилегированныйРежим(Ложь);
	Пока ВыборкаУчетныхЗаписей.Следующий() Цикл
		СертификатыУчетныхЗаписей = Новый Массив;
		ИдентификаторНабора = "ИД_";
		Выборка = ВыборкаУчетныхЗаписей.Выбрать();
		Пока Выборка.Следующий() Цикл
			Если СертификатыУчетныхЗаписей.Найти(Выборка.Сертификат) = Неопределено Тогда
				СертификатыУчетныхЗаписей.Добавить(Выборка.Сертификат);
				ИдентификаторНабора = ИдентификаторНабора + Строка(Выборка.Сертификат.УникальныйИдентификатор());
			КонецЕсли; 
		КонецЦикла;
		
		ИдентификаторНабора = СтрЗаменить(ИдентификаторНабора, "-", "_");
		СтруктураОписанияНабораСертификатов = Новый Структура("ИдентификаторНабора, Сертификаты", 
			ИдентификаторНабора, СертификатыУчетныхЗаписей);
		НаборыСертификатовУчетныхЗаписей.Вставить(ВыборкаУчетныхЗаписей.УчетнаяЗапись, СтруктураОписанияНабораСертификатов);
	КонецЦикла;
	
	УникальныеПараметрыПроверки = Новый Структура;
	Для Каждого СтрокаНастройки Из ПроверяемаяНастройка.Настройки Цикл
		Если Не СтрокаНастройки.Формировать
			Или СтрокаНастройки.ОбменБезПодписи Тогда
			Продолжить;
		КонецЕсли;
		МаршрутПодписания        = СтрокаНастройки.МаршрутПодписания;
		
		ПараметрыНабораСертификатов = НаборыСертификатовУчетныхЗаписей[ПроверяемаяНастройка.ИдентификаторОтправителя];
		Если ПараметрыНабораСертификатов <> Неопределено Тогда
			ИдентификаторМаршрута   = СтрЗаменить(Строка(МаршрутПодписания.УникальныйИдентификатор()), "-", "_");
			ИдентификаторПараметров = ПараметрыНабораСертификатов.ИдентификаторНабора + Строка(ИдентификаторМаршрута);
			
			СтруктураОписанияПараметров = Неопределено;
			Если Не УникальныеПараметрыПроверки.Свойство(ИдентификаторПараметров, СтруктураОписанияПараметров) Тогда
				СтруктураОписанияПараметров = Новый Структура;
				СтруктураОписанияПараметров.Вставить("Сертификаты",       ПараметрыНабораСертификатов.Сертификаты);
				СтруктураОписанияПараметров.Вставить("МаршрутПодписания", МаршрутПодписания);
				СтруктураОписанияПараметров.Вставить("ВидыДокументов",    Новый Массив);
				УникальныеПараметрыПроверки.Вставить(ИдентификаторПараметров, СтруктураОписанияПараметров);
			КонецЕсли;
			СтруктураОписанияПараметров.ВидыДокументов.Добавить(СтрокаНастройки.ВидДокумента);
		КонецЕсли;
	КонецЦикла;
	
	ОписаниеНастройки = Новый Структура("Отправитель, Получатель, Договор");
	ОписаниеНастройки.Отправитель = ПроверяемаяНастройка.Отправитель;
	ОписаниеНастройки.Получатель  = ПроверяемаяНастройка.Получатель;
	ОписаниеНастройки.Договор     = ПроверяемаяНастройка.Договор;
	НастройкаОбмена = РегистрыСведений.НастройкиОтправкиЭлектронныхДокументов.СоздатьКлючЗаписи(ОписаниеНастройки);
	ПредставлениеНастройки = ПредставлениеНастройкиОтправки(ОписаниеНастройки);
	
	Отказ = Ложь;
	
	Для Каждого НаборПараметровПроверки Из УникальныеПараметрыПроверки Цикл
		МаршрутПодписания = НаборПараметровПроверки.Значение.МаршрутПодписания;
		Сертификаты       = НаборПараметровПроверки.Значение.Сертификаты;
		ВидыДокументов    = НаборПараметровПроверки.Значение.ВидыДокументов;
		
		РезультатыПроверки = МаршрутыПодписанияБЭД.РезультатыПроверкиМаршрутаПоПараметрамНастройки(
			МаршрутПодписания, Сертификаты, ВидыДокументов);
			
		МаршрутыПодписанияБЭД.ВывестиРезультатыПроверкиМаршрута(РезультатыПроверки, 
			НастройкаОбмена, МаршрутПодписания, Отказ,, ПредставлениеНастройки, КонтекстДиагностики);
	КонецЦикла;
	
	Возврат Не Отказ;
	
КонецФункции

// Возвращает описание настройки для проверки соответствия сертификатов маршрутам, см. СертификатыСоответствуютМаршрутам.
// 
// Возвращаемое значение:
// 	Структура:
// * Настройки - см. НовыеПроверяемыеНастройкиДокументов
// * ИдентификаторОтправителя - Строка
// * ИдентификаторыОтправителя - Массив из Строка
// * Отправитель - ОпределяемыйТип.Организация
// * Получатель - ОпределяемыйТип.КонтрагентБЭД
// * Договор - ОпределяемыйТип.ДоговорСКонтрагентомЭДО
Функция НовоеОписаниеПроверяемойНастройки() Экспорт
	
	ОписаниеНастройки = Новый Структура;
	ОписаниеНастройки.Вставить("Отправитель");
	ОписаниеНастройки.Вставить("Получатель");
	ОписаниеНастройки.Вставить("Договор");
	ОписаниеНастройки.Вставить("ИдентификаторОтправителя", "");
	ОписаниеНастройки.Вставить("ИдентификаторыОтправителя", Новый Массив);
	ОписаниеНастройки.Вставить("Настройки", НовыеПроверяемыеНастройкиДокументов());
	
	Возврат ОписаниеНастройки;
	
КонецФункции

// Возвращает таблицу проверяемых настроек, см. НовоеОписаниеПроверяемойНастройки.
// 
// Возвращаемое значение:
// 	ТаблицаЗначений:
// * Формировать - Булево
// * МаршрутПодписания - СправочникСсылка.МаршрутыПодписания
// * ВидДокумента - СправочникСсылка.ВидыДокументовЭДО
// * ОбменБезПодписи - Булево
Функция НовыеПроверяемыеНастройкиДокументов()
	
	Настройки = Новый ТаблицаЗначений;
	Настройки.Колонки.Добавить("Формировать", Новый ОписаниеТипов("Булево"));
	Настройки.Колонки.Добавить("ОбменБезПодписи", Новый ОписаниеТипов("Булево"));
	Настройки.Колонки.Добавить("МаршрутПодписания", Новый ОписаниеТипов("СправочникСсылка.МаршрутыПодписания"));
	Настройки.Колонки.Добавить("ВидДокумента", Новый ОписаниеТипов("СправочникСсылка.ВидыДокументовЭДО"));
	
	Возврат Настройки;
	
КонецФункции

// Возвращает измерения для поиска настроек по договору
//
// Параметры:
//   Договор - ОпределяемыйТип.ДоговорСКонтрагентомЭДО - Договор контрагента
//
//  Возвращаемое значение:
//   Структура:
//    * ВладелецДоговора - Произвольный
//    * КлючНастроекОтправки - см. НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки
//
Функция НастройкаПоДоговоруКонтрагента(Знач Договор) Экспорт
	
	ИмяРеквизитаДоговора = ИнтеграцияЭДО.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("ВладелецДоговораКонтрагента");
	РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, ИмяРеквизитаДоговора);
	
	Результат = Новый Структура;
	Результат.Вставить("ВладелецДоговора", РеквизитыДоговора[ИмяРеквизитаДоговора]);
	Результат.Вставить("КлючНастроекОтправки", НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки());
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	НастройкиОтправкиЭлектронныхДокументов.Отправитель КАК Отправитель,
		|	НастройкиОтправкиЭлектронныхДокументов.Получатель КАК Получатель,
		|	НастройкиОтправкиЭлектронныхДокументов.Договор КАК Договор
		|ИЗ
		|	РегистрСведений.НастройкиОтправкиЭлектронныхДокументов КАК НастройкиОтправкиЭлектронныхДокументов
		|ГДЕ
		|	НастройкиОтправкиЭлектронныхДокументов.Договор = &Договор";
	
	Запрос.УстановитьПараметр("Договор", Договор);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Результат.ВладелецДоговора = Неопределено;
			Результат.КлючНастроекОтправки.Отправитель = ВыборкаДетальныеЗаписи.Отправитель;
			Результат.КлючНастроекОтправки.Получатель = ВыборкаДетальныеЗаписи.Получатель;
			Результат.КлючНастроекОтправки.Договор = ВыборкаДетальныеЗаписи.Договор;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ИдентификаторОрганизацииИнтеркампани(ПараметрыОрганизации, ИмяРеквизитаИННОрганизации, ИмяРеквизитаКППОрганизации)
	
	Ответ = ПараметрыОрганизации[ИмяРеквизитаИННОрганизации];
	
	Если ЗначениеЗаполнено(ПараметрыОрганизации[ИмяРеквизитаКППОрганизации]) Тогда
		Ответ = СтрШаблон(НСтр("ru = '%1_%2'"), ПараметрыОрганизации[ИмяРеквизитаИННОрганизации],
			ПараметрыОрганизации[ИмяРеквизитаКППОрганизации]);
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

Функция НоваяНастройкаЗаполненияДополнительныхПолей(СтруктураДанных = Неопределено) Экспорт
	
	ТаблицаНастроек = Новый ТаблицаЗначений;
	ТаблицаНастроек.Колонки.Добавить("Идентификатор");
	ТаблицаНастроек.Колонки.Добавить("Имя");
	ТаблицаНастроек.Колонки.Добавить("Представление");
	ТаблицаНастроек.Колонки.Добавить("Описание");
	ТаблицаНастроек.Колонки.Добавить("Правило");
	ТаблицаНастроек.Колонки.Добавить("Заполнение");
	ТаблицаНастроек.Колонки.Добавить("Значение");
	ТаблицаНастроек.Колонки.Добавить("Версия");
	ТаблицаНастроек.Колонки.Добавить("Раздел");
	
	Если СтруктураДанных <> Неопределено Тогда
		Для Каждого НастройкаПоля Из СтруктураДанных Цикл
			ЗаполнитьЗначенияСвойств(ТаблицаНастроек.Добавить(), НастройкаПоля);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТаблицаНастроек;
	
КонецФункции

Функция СоглашениеОбОбменеЭлектроннымиДокументами(Организация, Контрагент, Договор) Экспорт
	
	НастройкаЭДО = СсылкаНаОбъектНастройкиЭДО(Организация, Контрагент, Договор);
	
	Результат = Новый Структура;
	Результат.Вставить("НастройкаЭДО", НастройкаЭДО);
	Результат.Вставить("АдресСоглашения", СформироватьСоглашениеПоШаблону(НастройкаЭДО));
	
	Возврат Результат;
	
КонецФункции

Функция ОтправитьКаталогТоваров(НастройкаЭДО, АдресТаблицыТоваров, РезультатПолученияОтпечатков) Экспорт
	
	НаборДействий = Новый Соответствие;
	ЭлектронныеДокументыЭДОКлиентСервер.ДобавитьДействие(НаборДействий, ПредопределенноеЗначение(
		"Перечисление.ДействияПоЭДО.Сформировать"));
	ЭлектронныеДокументыЭДОКлиентСервер.ДобавитьДействие(НаборДействий, ПредопределенноеЗначение(
		"Перечисление.ДействияПоЭДО.Подписать"));
	ЭлектронныеДокументыЭДОКлиентСервер.ДобавитьДействие(НаборДействий, ПредопределенноеЗначение(
		"Перечисление.ДействияПоЭДО.ПодготовитьКОтправке"));
	ЭлектронныеДокументыЭДОКлиентСервер.ДобавитьДействие(НаборДействий, ПредопределенноеЗначение(
		"Перечисление.ДействияПоЭДО.Отправить"));
		
	ПараметрыВыполненияДействийПоЭДО = ЭлектронныеДокументыЭДОКлиентСервер.НовыеПараметрыВыполненияДействийПоЭДО();
	ПараметрыВыполненияДействийПоЭДО.ОтпечаткиСертификатов = РезультатПолученияОтпечатков;
	ПараметрыВыполненияДействийПоЭДО.НаборДействий = НаборДействий;
	ПараметрыВыполненияДействийПоЭДО.ОбъектыДействий.ОбъектыУчета.Добавить(НастройкаЭДО);
	ПараметрыВыполненияДействийПоЭДО.ДополнительныеДанныеОбъектов.Вставить(НастройкаЭДО, ПолучитьИзВременногоХранилища(
		АдресТаблицыТоваров));
	Возврат ЭлектронныеДокументыЭДО.ВыполнитьДействияПоЭДОВФоне(ПараметрыВыполненияДействийПоЭДО);
	
КонецФункции

#Область СформироватьСоглашениеПоШаблону

Функция СформироватьСоглашениеПоШаблону(НастройкаЭДО)
	
	АдресХранилища = Неопределено;
	
	ИмяМакета = "ПФ_DOC_СоглашениеОбОбменеЭлектроннымиДокументами";
	МакетИДанныеОбъекта = ПодготовитьДанныеПечатиСоглашенияПолучитьМакет(НастройкаЭДО, ИмяМакета);
	
	Области               = МакетИДанныеОбъекта.Макеты.ОписаниеОбластей;
	ДвоичныеДанныеМакетов = МакетИДанныеОбъекта.Макеты.ДвоичныеДанныеМакетов;
	ДанныеОбъекта = МакетИДанныеОбъекта.Данные[НастройкаЭДО][ИмяМакета];
	
	Макет = УправлениеПечатью.ИнициализироватьМакетОфисногоДокумента(ДвоичныеДанныеМакетов[ИмяМакета], "");
	Если Макет <> Неопределено Тогда
		Попытка
			ПечатнаяФорма = УправлениеПечатью.ИнициализироватьПечатнуюФорму("",, Макет);
			Если ПечатнаяФорма <> Неопределено Тогда
				// Вывод обычных областей с параметрами.
				Область = УправлениеПечатью.ОбластьМакета(Макет, Области[ИмяМакета]["Шапка"]);
				УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
				
				АдресХранилища = УправлениеПечатью.СформироватьДокумент(ПечатнаяФорма);
			КонецЕсли;
		Исключение
			ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЕсли;
		
	УправлениеПечатью.ОчиститьСсылки(ПечатнаяФорма);
	
	Если АдресХранилища <> Неопределено Тогда
		АдресХранилища = ПоместитьДанныеСоглашенияВоВременноеХранилище(НастройкаЭДО, АдресХранилища);
	КонецЕсли;
	
	Возврат АдресХранилища;
	
КонецФункции

Функция ПодготовитьДанныеПечатиСоглашенияПолучитьМакет(НастройкаЭДО, ИмяМакета)
	
	РеквизитыНастройки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НастройкаЭДО, "Организация, Контрагент");
	Сторона1 = ПредставлениеЮрФизЛица(РеквизитыНастройки.Организация);
	Сторона2 = ПредставлениеЮрФизЛица(РеквизитыНастройки.Контрагент);
	
	ДанныеОрганизации = ИнтеграцияЭДО.РегистрационныеДанныеОрганизации(РеквизитыНастройки.Организация);
	
	Город = "";
	Если ДанныеОрганизации.Свойство("Город", Город) И НЕ ЗначениеЗаполнено(Город)
		И ДанныеОрганизации.Свойство("КодРегиона") И ЗначениеЗаполнено(ДанныеОрганизации.КодРегиона) Тогда
		
		Если ДанныеОрганизации.КодРегиона = "77" // Москва
			ИЛИ ДанныеОрганизации.КодРегиона = "78" // Санкт-Петербург
			ИЛИ ДанныеОрганизации.КодРегиона = "92" // Севастополь
			ИЛИ ДанныеОрганизации.КодРегиона = "99" Тогда // Байконур и иные территории
			
			Город = АдресныйКлассификатор.НаименованиеРегионаПоКоду(ДанныеОрганизации.КодРегиона);
		КонецЕсли;
	КонецЕсли;
	
	Субъект = Новый Структура;
	Субъект.Вставить("НастройкаЭДО", НастройкаЭДО);
	Субъект.Вставить("Город",        Город);
	Субъект.Вставить("Дата",         Формат(ТекущаяДатаСеанса(), "ДЛФ=DD"));
	Субъект.Вставить("Сторона1",     Сторона1);
	Субъект.Вставить("Сторона2",     Сторона2);
	
	Субъекты = Новый Массив;
	Субъекты.Добавить(Субъект);
	
	ИмяМенеджераПечати = "Обработка.НастройкиОтправкиЭДО";
	МакетИДанныеОбъекта = УправлениеПечатьюВызовСервера.МакетыИДанныеОбъектовДляПечати(ИмяМенеджераПечати,
		ИмяМакета, Субъекты);
	
	Возврат МакетИДанныеОбъекта;
	
КонецФункции

Функция ПоместитьДанныеСоглашенияВоВременноеХранилище(НастройкаЭДО, АдресХранилища)
	
	ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	СтруктураФайла  = Новый Структура;
	СтруктураФайла.Вставить("ИмяФайла",                           НСтр("ru = 'Соглашение об обмене электронными документами.docx'"));
	СтруктураФайла.Вставить("Наименование",                       НСтр("ru = 'Соглашение об обмене электронными документами'"));
	СтруктураФайла.Вставить("Расширение",                         "docx");
	СтруктураФайла.Вставить("Размер",                             ДвоичныеДанныеФайла.Размер());
	СтруктураФайла.Вставить("Редактирует",                        Неопределено);
	СтруктураФайла.Вставить("ПодписанЭП",                         Ложь);
	СтруктураФайла.Вставить("Зашифрован",                         Ложь);
	СтруктураФайла.Вставить("ФайлРедактируется",                  Ложь);
	СтруктураФайла.Вставить("СсылкаНаДвоичныеДанныеФайла",        АдресХранилища);
	СтруктураФайла.Вставить("ДатаМодификацииУниверсальная",       ТекущаяУниверсальнаяДата());
	СтруктураФайла.Вставить("РедактируетТекущийПользователь", Ложь);
	АдресХранилища = ПоместитьВоВременноеХранилище(СтруктураФайла, Новый УникальныйИдентификатор);
	Возврат АдресХранилища;
	
КонецФункции

Функция ПредставлениеЮрФизЛица(ЮрФизЛицо)
	
	Результат = "";
	
	Сведения = ИнтеграцияЭДО.ДанныеЮрФизЛица(ЮрФизЛицо);
	
	Если Сведения.Свойство("ПолноеНаименование") И ЗначениеЗаполнено(Сведения.ПолноеНаименование) Тогда
		Результат = Сведения.ПолноеНаименование;
	Иначе
		Результат = Строка(ЮрФизЛицо);
	КонецЕсли;
	
	Если Сведения.Свойство("ИНН") И ЗначениеЗаполнено(Сведения.ИНН) Тогда
		Результат = Результат + " " + СтрШаблон(НСтр("ru = 'ИНН %1'"), Сведения.ИНН);
		Если Сведения.Свойство("КПП") И ЗначениеЗаполнено(Сведения.КПП) Тогда
			Результат = Результат + " " + СтрШаблон(НСтр("ru = 'КПП %1'"), Сведения.КПП);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти