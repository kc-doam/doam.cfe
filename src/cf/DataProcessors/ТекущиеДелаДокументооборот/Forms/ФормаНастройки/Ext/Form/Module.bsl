﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Параметры.ИндексВиджета) Тогда
		ТекстИсключения = НСтр("ru = 'Не указан обязательный параметр формы ИндексВиджета.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	СохраненныеЗначенияРеквизитов = ХранилищеСистемныхНастроек.Загрузить(ИмяФормы + "/ТекущиеДанные");
	Если СохраненныеЗначенияРеквизитов <> Неопределено Тогда
		ОтображатьУдаленные = СохраненныеЗначенияРеквизитов.Получить("ОтображатьУдаленные");
		ОтображатьТолькоМоиПапки = СохраненныеЗначенияРеквизитов.Получить("ОтображатьТолькоМоиПапки");
	КонецЕсли;
	
	Элементы.Виджет.СписокВыбора.ЗагрузитьЗначения(Справочники.Виджеты.ДоступныеВиджеты());
	
	Виджет = РегистрыСведений.НастройкиТекущихДел.ВиджетПоИндексу(Параметры.ИндексВиджета);
	
	ЗаполнитьПараметрыВиджета();
	
	Элементы.ДеревоПапокКонтекстноеМенюТолькоМоиПапки.Пометка = ОтображатьТолькоМоиПапки;
	Элементы.ДеревоПапокКонтекстноеМенюОтображатьУдаленные.Пометка = ОтображатьУдаленные;
	
	СостояниеДереваПапок = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		ЭтаФорма.ИмяФормы,
		"СостояниеДерева",
		Неопределено);
	
	Если Не ЗначениеЗаполнено(Виджет) Тогда
		Элементы.УдалитьВиджет1.Видимость = Ложь;
		Элементы.УдалитьВиджет2.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если СостояниеДереваПапок <> Неопределено Тогда
		ВосстановитьСостояниеДереваПапок(СостояниеДереваПапок);
	КонецЕсли;
	
	ОбновитьСтроковоеПредставлениеВыбранныхПапок();
	
	КоличествоПоказателей = Показатели.Количество();
	КоличествоПапокПисем = ДеревоПапок.ПолучитьЭлементы().Количество();
	
	Если КоличествоПоказателей = 0 И КоличествоПапокПисем = 0 Тогда
		Элементы.ГруппаКоманды.ТекущаяСтраница = Элементы.ГруппаГотовоОтмена;
	Иначе
		Элементы.ГруппаКоманды.ТекущаяСтраница = Элементы.ГруппаПродолжитьОтмена;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВиджетПриИзменении(Элемент)
	
	ЗаполнитьПараметрыВиджета();
	
	КоличествоПоказателей = Показатели.Количество();
	КоличествоПапокПисем = ДеревоПапок.ПолучитьЭлементы().Количество();
	
	Если КоличествоПапокПисем > 0 Тогда
		Если СостояниеДереваПапок <> Неопределено Тогда
			ВосстановитьСостояниеДереваПапок(СостояниеДереваПапок);
		КонецЕсли;
		
		ОбновитьСтроковоеПредставлениеВыбранныхПапок();
	КонецЕсли;
	
	Если КоличествоПоказателей = 0 И КоличествоПапокПисем = 0 Тогда
		Элементы.ГруппаКоманды.ТекущаяСтраница = Элементы.ГруппаГотовоОтмена;
	Иначе
		Элементы.ГруппаКоманды.ТекущаяСтраница = Элементы.ГруппаПродолжитьОтмена;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПапок

&НаКлиенте
Процедура ДеревоПапокВыбранаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоПапок.ТекущиеДанные;
	
	ТекущаяСтрока = Элементы.ДеревоПапок.ТекущаяСтрока;
	ЭлементДерева = ДеревоПапок.НайтиПоИдентификатору(ТекущаяСтрока);
	ПометитьЭлементДереваВключаяДочерние(ЭлементДерева, ТекущиеДанные.Выбрана);
	
	ОбновитьСтроковоеПредставлениеВыбранныхПапок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ТолькоМоиПапки(Команда)
	
	СостояниеДереваПапок = ЗапомнитьСостояниеДереваПапок();
	
	ОтображатьТолькоМоиПапки = Не ОтображатьТолькоМоиПапки;
	Элементы.ДеревоПапокКонтекстноеМенюТолькоМоиПапки.Пометка = ОтображатьТолькоМоиПапки;
	ЗаполнитьПараметрыВиджета();
	
	ВосстановитьСостояниеДереваПапок(СостояниеДереваПапок);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьУдаленные(Команда)
	
	СостояниеДереваПапок = ЗапомнитьСостояниеДереваПапок();
	
	ОтображатьУдаленные = Не ОтображатьУдаленные;
	Элементы.ДеревоПапокКонтекстноеМенюОтображатьУдаленные.Пометка = ОтображатьУдаленные;
	ЗаполнитьПараметрыВиджета();
	
	ВосстановитьСостояниеДереваПапок(СостояниеДереваПапок);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьНастройку(Команда)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборТипаВиджета
		И Виджет = ПредопределенноеЗначение("Справочник.Виджеты.Почта") Тогда
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборПапокПисем;
		Элементы.ГруппаКоманды.ТекущаяСтраница = Элементы.ГруппаПродолжитьНазад;
	Иначе
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаНастройкаПороговыхЗначений;
		Элементы.ГруппаКоманды.ТекущаяСтраница = Элементы.ГруппаГотовоНазад;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаНастройкаПороговыхЗначений
		И Виджет = ПредопределенноеЗначение("Справочник.Виджеты.Почта") Тогда
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборПапокПисем;
		Элементы.ГруппаКоманды.ТекущаяСтраница = Элементы.ГруппаПродолжитьНазад;
	Иначе
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборТипаВиджета;
		Элементы.ГруппаКоманды.ТекущаяСтраница = Элементы.ГруппаПродолжитьОтмена;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	НастройкиВиджета = ТекущиеДелаДокументооборотКлиентСервер.СтруктураВиджетаФормы();
	НастройкиВиджета.Виджет = Виджет;
	
	Для Каждого СтрПоказатель Из Показатели Цикл
		Показатель = ТекущиеДелаДокументооборотКлиентСервер.СтруктураПоказателяВиджета();
		ЗаполнитьЗначенияСвойств(Показатель, СтрПоказатель);
		НастройкиВиджета.Показатели.Добавить(Показатель);
	КонецЦикла;
	
	СписокВыбранныхПапок = Новый Массив;
	Для Каждого СтрокаВыбраннойПапки из ВыбранныеПапки Цикл
		СписокВыбранныхПапок.Добавить(СтрокаВыбраннойПапки.Ссылка);
	КонецЦикла;
	НастройкиВиджета.ПапкиПисем = СписокВыбранныхПапок;
	
	ТекущиеДелаДокументооборотСервер.ЗаписатьНастройкиВиджетаФормы(
		"Виджет" + Параметры.ИндексВиджета,
		НастройкиВиджета);
		
	Если Виджет = ПредопределенноеЗначение("Справочник.Виджеты.Почта") Тогда
		СостояниеДереваПапок = ЗапомнитьСостояниеДереваПапок();
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
			ЭтаФорма.ИмяФормы, "СостояниеДерева", СостояниеДереваПапок);
	КонецЕсли;
	
	Закрыть(Виджет);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВиджет(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗавершенияУдаленияВиджета", ЭтотОбъект, Параметры.ИндексВиджета);
		
	ТекстВопроса = НСтр("ru = 'Вы действительно хотите удалить этот виджет из окна ""Текущие дела""?'");
	
	КнопкиВопроса = Новый СписокЗначений;
	КнопкиВопроса.Добавить(Истина, НСтр("ru = 'Удалить'"));
	КнопкиВопроса.Добавить(Ложь, НСтр("ru = 'Отмена'"));
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, КнопкиВопроса,, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершенияУдаленияВиджета(Результат, ИндексВиджета) Экспорт
	
	Если Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	Виджет = ПредопределенноеЗначение("Справочник.Виджеты.ПустаяСсылка");
	
	НастройкиВиджета = ТекущиеДелаДокументооборотКлиентСервер.СтруктураВиджетаФормы();
	НастройкиВиджета.Виджет = Виджет;
	
	ТекущиеДелаДокументооборотСервер.ЗаписатьНастройкиВиджетаФормы(
		"Виджет" + ИндексВиджета,
		НастройкиВиджета);
		
	Закрыть(Виджет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет параметры текущего выбранного виджета.
//
// Параметры:
//   Виджет - СправочникСсылка.Виджеты
//
&НаСервере
Процедура ЗаполнитьПараметрыВиджета()
	
	НастройкиВиджета = ТекущиеДелаДокументооборотСервер.НастройкиВиджета(Виджет);
	
	Показатели.Очистить();
	ВыбранныеПапки.Очистить();
	ВыбранныеПапкиСтрока = "";
	ДеревоПапок.ПолучитьЭлементы().Очистить();
	
	Если НастройкиВиджета.Показатели.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Заполнение таблицы пороговых значений показателей
	Для Каждого СтрПоказатель Из НастройкиВиджета.Показатели Цикл
		ЗаполнитьЗначенияСвойств(Показатели.Добавить(), СтрПоказатель);
	КонецЦикла;
	
	// Заполнение дерева папок писем
	Если Виджет = ПредопределенноеЗначение("Справочник.Виджеты.Почта") Тогда
		
		ЗаполнитьДеревоПапок(НастройкиВиджета.ПапкиПисем);
		
		ДобавитьПапкиВСписокВыбранныхСервер(НастройкиВиджета.ПапкиПисем);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_ДеревоПапок

&НаСервере
Процедура ЗаполнитьДеревоПапок(СписокВыбранныхПапок)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПапкиПисем.Ссылка КАК Ссылка,
		|	ВЫБОР
		|		КОГДА ПапкиПисем.Ссылка В (&СписокВыбранныхПапок)
		|			ТОГДА Истина
		|		ИНАЧЕ Ложь
		|	КОНЕЦ КАК Выбрана,
		|	ПапкиПисем.ПометкаУдаления КАК ПометкаУдаления,
		|	ПапкиПисем.Представление КАК Представление,
		|	ПапкиПисем.ВидПапки КАК ВидПапки,
		|	ВЫБОР
		|		КОГДА ПапкиПисем.ПометкаУдаления
		|			ТОГДА 1
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Черновики)
		|			ТОГДА 2
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Корзина)
		|			ТОГДА 4
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК НомерКартинки,
		|	ВЫБОР
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Входящие)
		|			ТОГДА 1
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Исходящие)
		|			ТОГДА 2
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Отправленные)
		|			ТОГДА 3
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Корзина)
		|			ТОГДА 5
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Черновики)
		|			ТОГДА 6
		|		ИНАЧЕ 7
		|	КОНЕЦ КАК Порядок,
		|	ПапкиПисем.ВариантОтображенияКоличестваПисем,");
		
	Если ОтображатьТолькоМоиПапки Тогда
		Запрос.Текст = Запрос.Текст +
			"
			|	ЛОЖЬ КАК ПапкаБыстрогоДоступа";
	Иначе
		Запрос.Текст = Запрос.Текст +
			"
			|ВЫБОР
			|	КОГДА ПапкиПисемБыстрогоДоступа.Папка ЕСТЬ NULL 
			|		ТОГДА ЛОЖЬ
			|	ИНАЧЕ ИСТИНА
			|КОНЕЦ КАК ПапкаБыстрогоДоступа"
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст +
		"
		|ИЗ
		|	Справочник.ПапкиПисем КАК ПапкиПисем
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПапкиПисемБыстрогоДоступа КАК ПапкиПисемБыстрогоДоступа
		|	ПО (ПапкиПисемБыстрогоДоступа.Папка = ПапкиПисем.Ссылка И ПапкиПисемБыстрогоДоступа.Пользователь = &ТекущийПользователь)
		|ГДЕ
		|	((НЕ ПапкиПисем.ПометкаУдаления)
		|			ИЛИ &ОтображатьУдаленные)";
		
	Если ОтображатьТолькоМоиПапки Тогда
		Запрос.Текст = Запрос.Текст +
			"
			|	И ПапкиПисем.Ссылка В ИЕРАРХИИ
			|		(ВЫБРАТЬ
			|			ПапкиПисемБыстрогоДоступа.Папка
			|		ИЗ
			|			РегистрСведений.ПапкиПисемБыстрогоДоступа КАК ПапкиПисемБыстрогоДоступа
			|		ГДЕ
			|			ПапкиПисемБыстрогоДоступа.Пользователь = &ТекущийПользователь)";
	КонецЕсли;
		
	Запрос.Текст = Запрос.Текст +
		"
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка ИЕРАРХИЯ";
		
	Запрос.УстановитьПараметр("ОтображатьУдаленные", ОтображатьУдаленные);
	Запрос.УстановитьПараметр("ТекущийПользователь", ПользователиКлиентСервер.ТекущийПользователь());
	
	Запрос.УстановитьПараметр("СписокВыбранныхПапок", СписокВыбранныхПапок);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	ТекУчетнаяЗапись = Неопределено;
	СтрокаУчетнаяЗапись = Неопределено;
	
	ДеревоПапокОбъект = РеквизитФормыВЗначение("ДеревоПапок");
	ДеревоПапокОбъект.Строки.Очистить();
	ДобавитьПапкиВДерево(ДеревоПапокОбъект.Строки, Дерево.Строки);
	СортироватьИерархически(ДеревоПапокОбъект.Строки, "Порядок, Наименование");
	
	ЗначениеВДанныеФормы(ДеревоПапокОбъект, ДеревоПапок);
	
КонецПроцедуры

&НаСервере
Процедура СортироватьИерархически(СтрокиДерева, Знач Колонки)
	
	СтрокиДерева.Сортировать(Колонки);
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		Если СтрокаДерева.Строки.Количество() > 0 Тогда
			СортироватьИерархически(СтрокаДерева.Строки, Колонки);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПапкиВДерево(ДеревоСтроки, ИсточникСтроки)
	
	МенеджерПапокПисем = Справочники.ПапкиПисем;
	
	Для Каждого ПапкаИнфо Из ИсточникСтроки Цикл
		СтрокаПапка = ДеревоСтроки.Добавить();
		СтрокаПапка.Ссылка = ПапкаИнфо.Ссылка;
		СтрокаПапка.Выбрана = ПапкаИнфо.Выбрана;
		СтрокаПапка.Наименование = ПапкаИнфо.Представление;
		Попытка
			СтрокаПапка.ПолныйПуть = МенеджерПапокПисем.ПолучитьПолныйПутьПапки(ПапкаИнфо.Ссылка);
		Исключение
			// Если полный путь не удается построить, то выводим только наименование текущей папки.
			// Такое возможно, если у текущего пользователя нет доступа к вышестоящим папкам.
			СтрокаПапка.ПолныйПуть = СтрокаПапка.Наименование;
		КонецПопытки;
		СтрокаПапка.ВидПапки = ПапкаИнфо.ВидПапки;
		СтрокаПапка.Порядок = ПапкаИнфо.Порядок;
		СтрокаПапка.НомерКартинки = ПапкаИнфо.НомерКартинки;
		СтрокаПапка.ВариантОтображенияКоличестваПисем = ПапкаИнфо.ВариантОтображенияКоличестваПисем;
		СтрокаПапка.ПапкаБыстрогоДоступа = ПапкаИнфо.ПапкаБыстрогоДоступа;
		СтрокаПапка.ПометкаУдаления = ПапкаИнфо.ПометкаУдаления;
		ДобавитьПапкиВДерево(СтрокаПапка.Строки, ПапкаИнфо.Строки);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ЗапомнитьСостояниеДереваПапок()
	
	Состояние = Новый Структура;
	Состояние.Вставить("ТекСсылка", Неопределено);
	Если Элементы.ДеревоПапок.ТекущиеДанные <> Неопределено Тогда
		ТекущиеДанные = Элементы.ДеревоПапок.ТекущиеДанные;
		Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
			Состояние.ТекСсылка = ТекущиеДанные.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Дерево", ДеревоПапок);
	Контекст.Вставить("ФормаДерево", Элементы.ДеревоПапок);
	Контекст.Вставить("Состояние", Новый Соответствие);
	ОбойтиДерево(ДеревоПапок.ПолучитьЭлементы(), Контекст, "ЗапомнитьСостояниеРазвернут");
	Состояние.Вставить("Развернут", Контекст.Состояние);
	
	Возврат Состояние;
	
КонецФункции

&НаКлиенте
Функция ЗапомнитьСостояниеРазвернут(Элемент, Контекст)
	
	ИдентификаторСтроки = Элемент.ПолучитьИдентификатор();
	ТекДанные = Контекст.Дерево.НайтиПоИдентификатору(ИдентификаторСтроки);
	Контекст.Состояние.Вставить(ТекДанные.Ссылка, Контекст.ФормаДерево.Развернут(ИдентификаторСтроки));
	
КонецФункции

&НаКлиенте
Процедура ВосстановитьСостояниеДереваПапок(Состояние)
	
	Если Состояние = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Дерево", ДеревоПапок);
	Контекст.Вставить("ФормаДерево", Элементы.ДеревоПапок);
	Контекст.Вставить("Состояние", Состояние.Развернут);
	Контекст.Вставить("ТекСсылка", Состояние.ТекСсылка);
	ОбойтиДерево(ДеревоПапок.ПолучитьЭлементы(), Контекст, "УстановитьСостояниеРазвернут");
	
КонецПроцедуры

&НаКлиенте
Функция УстановитьСостояниеРазвернут(Элемент, Контекст)
	
	ИдентификаторСтроки = Элемент.ПолучитьИдентификатор();
	ТекДанные = Контекст.Дерево.НайтиПоИдентификатору(ИдентификаторСтроки);
	Если Контекст.Состояние.Получить(ТекДанные.Ссылка) = Истина Тогда
		Контекст.ФормаДерево.Развернуть(ИдентификаторСтроки);
	Иначе
		Контекст.ФормаДерево.Свернуть(ИдентификаторСтроки);
	КонецЕсли;
	Если ТекДанные.Ссылка = Контекст.ТекСсылка Тогда
		Контекст.ФормаДерево.ТекущаяСтрока = ИдентификаторСтроки;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ОбойтиДерево(ДеревоЭлементы, Контекст, ИмяПроцедуры)
	
	Для Каждого Элемент Из ДеревоЭлементы Цикл
		// Рекурсивный вызов
		ОбойтиДерево(Элемент.ПолучитьЭлементы(), Контекст, ИмяПроцедуры);
		Результат = Вычислить(ИмяПроцедуры + "(Элемент, Контекст)");
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПапкиВСписокВыбранныхСервер(Папки)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПапкиПисем.Ссылка КАК Ссылка,
		|	ПапкиПисем.ПометкаУдаления КАК ПометкаУдаления,
		|	ВЫБОР
		|		КОГДА ПапкиПисем.ПометкаУдаления
		|			ТОГДА 1
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Черновики)
		|			ТОГДА 2
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Корзина)
		|			ТОГДА 4
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК НомерКартинки,
		|	ВЫБОР
		|		КОГДА ПапкиПисемБыстрогоДоступа.Папка ЕСТЬ NULL 
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ПапкаБыстрогоДоступа
		|ИЗ
		|	Справочник.ПапкиПисем КАК ПапкиПисем
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПапкиПисемБыстрогоДоступа КАК ПапкиПисемБыстрогоДоступа
		|		ПО (ПапкиПисемБыстрогоДоступа.Папка = ПапкиПисем.Ссылка)
		|			И (ПапкиПисемБыстрогоДоступа.Пользователь = &ТекущийПользователь)
		|ГДЕ
		|	(ПапкиПисем.Ссылка В (&Папки))";
		
	Запрос.УстановитьПараметр("ТекущийПользователь", ПользователиКлиентСервер.ТекущийПользователь());
	Запрос.УстановитьПараметр("Папки", Папки);
		
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ВыбранныеПапки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		Попытка
			НоваяСтрока.ПолныйПуть = Справочники.ПапкиПисем.ПолучитьПолныйПутьПапки(Выборка.Ссылка);
		Исключение
			// Если полный путь не удается построить, то выводим только наименование текущей папки.
			// Такое возможно, если у текущего пользователя нет доступа к вышестоящим папкам.
			НоваяСтрока.ПолныйПуть = Строка(Выборка.Ссылка);
		КонецПопытки;
	КонецЦикла;	
		
КонецПроцедуры

&НаКлиенте
Процедура ПометитьЭлементДереваВключаяДочерние(ЭлементДерева, ПометкаВыбора)
	
	ЭлементДерева.Выбрана = ПометкаВыбора;
	
	ПараметрыОтбора = Новый Структура("Ссылка", ЭлементДерева.Ссылка);
	Если ПометкаВыбора Тогда
		Если ВыбранныеПапки.НайтиСтроки(ПараметрыОтбора).Количество() = 0 Тогда
			НоваяСтрока = ВыбранныеПапки.Добавить();
			ЗаполнитьЗначенияСвойств(
				НоваяСтрока, 
				ДеревоПапок.НайтиПоИдентификатору(ЭлементДерева.ПолучитьИдентификатор()));	
		КонецЕсли;		
	Иначе			
		НайденныеСтроки = ВыбранныеПапки.НайтиСтроки(ПараметрыОтбора);
		Если НайденныеСтроки.Количество() > 0 Тогда
			ВыбранныеПапки.Удалить(НайденныеСтроки[0]);
		КонецЕсли;
	КонецЕсли;		
	
	ПодчиненныеЭлементыДерева = ЭлементДерева.ПолучитьЭлементы();
	Для Каждого ПодчиненныйЭлементДерева Из ПодчиненныеЭлементыДерева Цикл		
		ПометитьЭлементДереваВключаяДочерние(ПодчиненныйЭлементДерева, ПометкаВыбора);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтроковоеПредставлениеВыбранныхПапок()
	
	ВыбранныеПапкиСтрока = "";
	
	Для каждого СтрокаПапки Из ВыбранныеПапки Цикл
		Если ЗначениеЗаполнено(ВыбранныеПапкиСтрока) Тогда
			ВыбранныеПапкиСтрока = ВыбранныеПапкиСтрока + "; ";
		КонецЕсли;
		ВыбранныеПапкиСтрока = ВыбранныеПапкиСтрока + СтрокаПапки.ПолныйПуть;		
	КонецЦикла; 
		
КонецПроцедуры

#КонецОбласти

