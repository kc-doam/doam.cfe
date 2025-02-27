﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// УправлениеДоступом

Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат 
		"Ссылка,
		|Папка,
		|ГрифДоступа,
		|Организация,
		|Подразделение,
		|Руководитель";
	
КонецФункции

// Проверяет наличие метода.
// 
Функция ЕстьМетодЗаполнитьДескрипторыОбъекта() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Заполняет переданную таблицу дескрипторов объекта.
// 
Процедура ЗаполнитьДескрипторыОбъекта(ОбъектДоступа, ТаблицаДескрипторов, ПротоколРасчетаПрав = Неопределено) Экспорт
	
	ДокументооборотПраваДоступа.ЗаполнитьДескрипторыОбъектаСтандартно(
		ОбъектДоступа, ТаблицаДескрипторов);
	
	ДокументооборотПраваДоступа.ДобавитьИндивидуальныйДескриптор(
		ОбъектДоступа, ТаблицаДескрипторов, ОбъектДоступа.Руководитель, Истина);
	
	Если ПротоколРасчетаПрав <> Неопределено Тогда
		ЗаписьПротокола = Новый Структура("Элемент, Описание",
			ОбъектДоступа.Руководитель, НСтр("ru = 'Руководитель'"));
		ПротоколРасчетаПрав.Добавить(ЗаписьПротокола);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет переданный дескриптор доступа 
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	ДескрипторДоступа.ГрифДоступа = ОбъектДоступа.ГрифДоступа;
	ДескрипторДоступа.Организация = ОбъектДоступа.Организация;
	ДескрипторДоступа.Подразделение = ОбъектДоступа.Подразделение;
	
	// Папка
	ДокументооборотПраваДоступа.ЗаполнитьПапкуДескриптораОбъекта(ОбъектДоступа, ДескрипторДоступа);
	
КонецПроцедуры

// Проверяет наличие метода.
// 
Функция ЕстьМетодПолучитьПравилаОбработкиНастроекПравПапки() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает таблицу значений с правилами обработки настроек прав папки,
// которые следует применять для расчета прав объекта
// 
Функция ПолучитьПравилаОбработкиНастроекПравПапки() Экспорт
	
	ТаблицаПравил = ДокументооборотПраваДоступа.ТаблицаПравилОбработкиНастроекПапки();
	
	Стр = ТаблицаПравил.Добавить();
	Стр.Настройка = "ЧтениеПапокИПроектов";
	Стр.Чтение = Истина;
	
	Стр = ТаблицаПравил.Добавить();
	Стр.Настройка = "ДобавлениеПапокИПроектов";
	Стр.Добавление = Истина;
	
	Стр = ТаблицаПравил.Добавить();
	Стр.Настройка = "ИзменениеПапокИПроектов";
	Стр.Изменение = Истина;
	
	Стр = ТаблицаПравил.Добавить();
	Стр.Настройка = "ПометкаУдаленияПапокИПроектов";
	Стр.Удаление = Истина;
	
	Возврат ТаблицаПравил;
	
КонецФункции

// Конец УправлениеДоступом

// Проверяет, подходит ли объект к шаблону бизнес-процесса
Функция ШаблонПодходитДляАвтозапускаБизнесПроцессаПоОбъекту(ШаблонСсылка, ПредметСсылка, Подписчик, ВидСобытия, Условие) Экспорт
	
	Возврат БизнесСобытияВызовСервера.ШаблонПодходитДляАвтозапускаБизнесПроцессаПоПредмету(ШаблонСсылка, 
		ПредметСсылка, Подписчик, ВидСобытия, Условие);
	
КонецФункции

// Возвращает признак наличия метода ДобавитьУчастниковВТаблицу у менеджера объекта
//
Функция ЕстьМетодДобавитьУчастниковВТаблицу() Экспорт
	Возврат Истина;
КонецФункции

// Добавляет участников документа в переданную таблицу
//
Процедура ДобавитьУчастниковВТаблицу(ТаблицаНабора, Проект) Экспорт
	
	Для Каждого ЧленКоманды Из Проект.ПроектнаяКоманда Цикл
		Если ТипЗнч(ЧленКоманды.Исполнитель) = Тип("СправочникСсылка.Пользователи")
			ИЛИ ТипЗнч(ЧленКоманды.Исполнитель) = Тип("СправочникСсылка.ПолныеРоли") Тогда
			
			РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(
				ТаблицаНабора, ЧленКоманды.Исполнитель);
			
		КонецЕсли;	
	КонецЦикла;
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Проект.Руководитель, Истина);
	
КонецПроцедуры

// Возвращает имя предмета процесса по умолчанию
//
Функция ПолучитьИмяПредметаПоУмолчанию(Ссылка) Экспорт
	
	Возврат НСтр("ru='Проект'");
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Карточка
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Справочник.Проекты";
	КомандаПечати.Идентификатор = "Карточка";
	КомандаПечати.Представление = НСтр("ru = 'Карточка проекта'");
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
    Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Карточка") Тогда

        // Формируем табличный документ и добавляем его в коллекцию печатных форм
        УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
            "Карточка", "Проект", ПечатьКарточки(МассивОбъектов, ОбъектыПечати, ПараметрыПечати),
			,
			"Справочник.Проекты.ПФ_MXL_Карточка");
			
	КонецЕсли;
		
КонецПроцедуры

Функция ПечатьКарточки(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ИспользоватьДополнительныеРеквизитыИСведения = ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеРеквизитыИСведения");
	
	// Создаем табличный документ и устанавливаем имя параметров печати
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПараметрыПечати_КарточкаСообщения";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.Проекты.ПФ_MXL_Карточка");
	ОбластьПроектШапка = Макет.ПолучитьОбласть("ПроектШапка");
	
	ПервыйДокумент = Истина;
	
	Для Каждого ОбъектПечати Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		// Запомним номер строки с которой начали выводить текущий документ
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;		
		
		// Заполнение шапки проекта
		ОбластьПроектШапка.Параметры.Наименование = ОбъектПечати.Наименование + " (" + ТипЗнч(ОбъектПечати) + ")";
		ОбластьПроектШапка.Параметры.Описание = ОбъектПечати.Описание;
		ОбластьПроектШапка.Параметры.РуководительПроекта = ОбъектПечати.Руководитель;
		ОбластьПроектШапка.Параметры.Заказчик = ОбъектПечати.Заказчик;
		ОбластьПроектШапка.Параметры.Начало = ОбъектПечати.ТекущийПланНачало;
		ОбластьПроектШапка.Параметры.Окончание = ОбъектПечати.ТекущийПланОкончание;
		ОбластьПроектШапка.Параметры.Трудозатраты = Строка(ОбъектПечати.ТекущийПланТрудозатраты);
		ОбластьПроектШапка.Параметры.Гриф = ОбъектПечати.ГрифДоступа;
		ОбластьПроектШапка.Параметры.Состояние = ОбъектПечати.Состояние;
		ОбластьПроектШапка.Параметры.Вид = ОбъектПечати.ВидПроекта;
		ОбластьПроектШапка.Параметры.Организация = ОбъектПечати.Организация;
		
		ТабличныйДокумент.Вывести(ОбластьПроектШапка);
		
		// Проектная команда
		Если ОбъектПечати.ПроектнаяКоманда.Количество() > 0 Тогда
			ОбластьКомандаШапка = Макет.ПолучитьОбласть("ПроектнаяКомандаШапка");
			ТабличныйДокумент.Вывести(ОбластьКомандаШапка);
			Для Каждого УчастникПроекта Из ОбъектПечати.ПроектнаяКоманда Цикл
				ОбластьКомандаСтрока = Макет.ПолучитьОбласть("ПроектнаяКомандаУчастник");
				ОбластьКомандаСтрока.Параметры.Участник = УчастникПроекта.Исполнитель;
				ОбластьКомандаСтрока.Параметры.РольУчастника = УчастникПроекта.РольВПроекте;
				ТабличныйДокумент.Вывести(ОбластьКомандаСтрока);
			КонецЦикла;
		КонецЕсли;
		
		// Контроль исполнения
		ЗапросПроектныеЗадачи = Новый Запрос;
		ЗапросПроектныеЗадачи.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ПроектныеЗадачи.Ссылка,
			|	ПроектныеЗадачи.Наименование,
			|	ПроектныеЗадачи.КодСДР КАК КодСДР,
			|	СрокиПроектныхЗадач.ТекущийПланНачало,
			|	СрокиПроектныхЗадач.ТекущийПланОкончание,
			|	ВЫБОР
			|		КОГДА СрокиПроектныхЗадач.ОкончаниеФакт <> ДАТАВРЕМЯ(1, 1, 1)
			|			ТОГДА &Завершены
			|		КОГДА СрокиПроектныхЗадач.НачалоФакт <> ДАТАВРЕМЯ(1, 1, 1)
			|				И СрокиПроектныхЗадач.ТекущийПланОкончание >= &ТекущаяДата
			|			ТОГДА &ВыполняютсяБезПросрочки
			|		КОГДА СрокиПроектныхЗадач.НачалоФакт <> ДАТАВРЕМЯ(1, 1, 1)
			|				И СрокиПроектныхЗадач.ТекущийПланОкончание < &ТекущаяДата
			|			ТОГДА &ВыполняютсяСПросрочкой
			|		КОГДА СрокиПроектныхЗадач.НачалоФакт = ДАТАВРЕМЯ(1, 1, 1)
			|				И СрокиПроектныхЗадач.ТекущийПланНачало < &ТекущаяДата
			|			ТОГДА &НеНачатыВовремя
			|		КОГДА СрокиПроектныхЗадач.НачалоФакт = ДАТАВРЕМЯ(1, 1, 1)
			|				И СрокиПроектныхЗадач.ТекущийПланНачало >= &ТекущаяДата
			|			ТОГДА &НеНачаты
			|	КОНЕЦ КАК ТекущееСостояниеПроектнойЗадачи,
			|	ПроектныеЗадачи.НомерЗадачиВУровне КАК НомерЗадачиВУровне
			|ИЗ
			|	Справочник.ПроектныеЗадачи КАК ПроектныеЗадачи
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СрокиПроектныхЗадач КАК СрокиПроектныхЗадач
			|		ПО ПроектныеЗадачи.Ссылка = СрокиПроектныхЗадач.ПроектнаяЗадача
			|ГДЕ
			|	ПроектныеЗадачи.Владелец = &Проект
			|	И НЕ ПроектныеЗадачи.ПометкаУдаления
			|
			|УПОРЯДОЧИТЬ ПО
			|	КодСДР,
			|	НомерЗадачиВУровне";
			
		ДатаФормирования = ТекущаяДатаСеанса();
		ЗапросПроектныеЗадачи.УстановитьПараметр("Проект", ОбъектПечати);
		ЗапросПроектныеЗадачи.УстановитьПараметр("ТекущаяДата", ДатаФормирования);
		ЗапросПроектныеЗадачи.УстановитьПараметр("Завершены", НСтр("ru = 'Завершены'"));
		ЗапросПроектныеЗадачи.УстановитьПараметр("ВыполняютсяБезПросрочки", НСтр("ru = 'Выполняются без просрочки'"));
		ЗапросПроектныеЗадачи.УстановитьПараметр("ВыполняютсяСПросрочкой", НСтр("ru = 'Выполняются c просрочкой'"));
		ЗапросПроектныеЗадачи.УстановитьПараметр("НеНачатыВовремя", НСтр("ru = 'Не начаты вовремя'"));
		ЗапросПроектныеЗадачи.УстановитьПараметр("НеНачаты", НСтр("ru = 'Не начаты'"));
		
		ТаблицаЗадачи = ЗапросПроектныеЗадачи.Выполнить().Выгрузить();
		
		Если ТаблицаЗадачи.Количество() > 0 Тогда
			ОбластьКонтрольВыполненияШапка = Макет.ПолучитьОбласть("КонтрольВыполненияШапка");
			ОбластьКонтрольВыполненияШапка.Параметры.ДатаФормирования = Формат(ДатаФормирования, "ДФ='dd.MM.yyyy HH:mm'");
			ТабличныйДокумент.Вывести(ОбластьКонтрольВыполненияШапка);
			
			ВывестиЗадачиВУказанномСостоянии(НСтр("ru = 'Завершены'"), ТабличныйДокумент, Макет, ТаблицаЗадачи);
			ВывестиЗадачиВУказанномСостоянии(НСтр("ru = 'Выполняются без просрочки'"), ТабличныйДокумент, Макет, ТаблицаЗадачи);
			ВывестиЗадачиВУказанномСостоянии(НСтр("ru = 'Выполняются c просрочкой'"), ТабличныйДокумент, Макет, ТаблицаЗадачи);
			ВывестиЗадачиВУказанномСостоянии(НСтр("ru = 'Не начаты вовремя'"), ТабличныйДокумент, Макет, ТаблицаЗадачи);
			ВывестиЗадачиВУказанномСостоянии(НСтр("ru = 'Не начаты'"), ТабличныйДокумент, Макет, ТаблицаЗадачи);
		КонецЕсли;
		
		// В табличном документе зададим имя области в которую был 
		// выведен объект. Нужно для возможности печати по-комплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ОбъектПечати);
	КонецЦикла;		

	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ВывестиЗадачиВУказанномСостоянии(Состояние, ТабличныйДокумент, Макет, ТаблицаЗадачи)
	
	ПараметрыОтбора = Новый Структура("ТекущееСостояниеПроектнойЗадачи", Состояние);
	НайденныеСтроки = ТаблицаЗадачи.НайтиСтроки(ПараметрыОтбора);
	Если НайденныеСтроки.Количество() > 0 Тогда
		ОбластьСостояниеСтрока = Макет.ПолучитьОбласть("СостояниеСтрока");
		ОбластьСостояниеСтрока.Параметры.Состояние = Состояние;
		ТабличныйДокумент.Вывести(ОбластьСостояниеСтрока);

		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			ОбластьЗадача = Макет.ПолучитьОбласть("ЗадачаСтрока");
			ОбластьЗадача.Параметры.КодСДР = НайденнаяСтрока.КодСДР;
			ОбластьЗадача.Параметры.Наименование = НайденнаяСтрока.Наименование;
			ОбластьЗадача.Параметры.НачалоПлан = Формат(НайденнаяСтрока.ТекущийПланНачало, "ДФ='dd.MM.yy HH:mm'");
			ОбластьЗадача.Параметры.ОкончаниеПлан = Формат(НайденнаяСтрока.ТекущийПланОкончание, "ДФ='dd.MM.yy HH:mm'");
			ТабличныйДокумент.Вывести(ОбластьЗадача);
		КонецЦикла;
	КонецЕсли;	
	
КонецПроцедуры

// ВерсионированиеОбъектов
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры
// Конец ВерсионированиеОбъектов

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
КонецПроцедуры

#КонецОбласти

#КонецЕсли