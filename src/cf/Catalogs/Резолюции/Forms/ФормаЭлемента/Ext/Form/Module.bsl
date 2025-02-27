﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовая = Объект.Ссылка.Пустая();
	
	Если ЭтоНовая Тогда
		Объект.АвторРезолюции	= ПользователиКлиентСервер.ТекущийПользователь();
		Объект.ДатаРезолюции	= ТекущаяДата();
		Объект.ВнесРезолюцию	= Объект.АвторРезолюции;
		Если Параметры.Свойство("Документ") Тогда
			Объект.Документ		= Параметры.Документ;
			Элементы.Документ.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьВидимость();
	УстановитьДоступность();
	УстановитьДоступностьКоманд();
	
	Если Параметры.Свойство("ОбъектСсылка") И ЗначениеЗаполнено(Параметры.ОбъектСсылка) Тогда
		Элементы.Документ.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("ТолькоПросмотр") И Параметры.ТолькоПросмотр = Истина Тогда 
		ЭтаФорма.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Параметры.Свойство("ТекстПредупреждения") Тогда
		ТекстПредупреждения = Параметры.ТекстПредупреждения;
	КонецЕсли;
	
	СохранениеВводимыхЗначений.ЗаполнитьСписокВыбора(ЭтаФорма, ЭлементыДляСохранения(), ЭтаФорма.ИмяФормы);
	
	ВидДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Документ, "ВидДокумента");
	ПодписыватьРезолюциюЭП = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидДокумента, "ПодписыватьРезолюцииЭП");
	
	Если Не ЭтаФорма.ТолькоПросмотр Тогда 
		Если Не Делопроизводство.ИзменениеРезолюцииДоступноПоСостоянию(ЭтаФорма) Тогда 
			ЭтаФорма.ТолькоПросмотр = Истина;
			ТекстПредупреждения = НСтр("ru = 'Для текущего состояния документа запрещено изменение резолюции.'");
		КонецЕсли;
	КонецЕсли;
	
	ЭтаФорма.Элементы.ГруппаПредупреждение.Видимость = ЗначениеЗаполнено(ТекстПредупреждения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ Объект.Подписана 
		И ТипЗнч(ПодписыватьРезолюциюЭП) = Тип("Булево")
		И ПодписыватьРезолюциюЭП
		И Не ПодписьУстановлена Тогда
			
		СоздатьЭП(ПараметрыЗаписи);
		
		Отказ = Истина;
		Возврат;
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЭтоНовая Тогда
		ТекущийОбъект.Наименование = РаботаСРезолюциямиКлиентСервер.ПолучитьНаименованиеРезолюции(ТекущийОбъект.Документ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	СохранениеВводимыхЗначений.ОбновитьСпискиВыбора(ЭтаФорма, ЭлементыДляСохранения(), ЭтаФорма.ИмяФормы);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если ПодписьУстановлена Тогда
		ПодписатьЭПНаСервере(ДанныеЭП.МассивДанныхДляЗанесенияВРегистр,
			ДанныеЭП.МассивАдресов);
		УстановитьВидимость();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("Запись_Резолюции", Объект.Документ);
	ЭтоНовая = Не ЭтоНовая;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АвторРезолюцииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникНачалоВыбора(
		Элемент, Объект.АвторРезолюции, СтандартнаяОбработка, ЭтаФорма, "АвторРезолюции");
	
КонецПроцедуры

&НаКлиенте
Процедура АвторРезолюцииАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникАвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АвторРезолюцииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникОкончаниеВводаТекста(
		Текст, ДанныеВыбора, СтандартнаяОбработка, ЭтаФорма, "АвторРезолюции");
		
КонецПроцедуры

&НаКлиенте
Процедура СтатусПроверкиЭПНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСЭПКлиент.ОткрытьПодпись(ДанныеЭП, УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьЭП(Команда)
	
	РаботаСЭПКлиент.ОткрытьПодпись(ДанныеЭП, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьЭП(Команда)
	
	СоздатьЭП();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЭП(Команда)
	
	МассивПодписей = Новый Массив;
	МассивПодписей.Добавить(ДанныеЭП);
	
	РаботаСЭПКлиент.ПроверитьПодписиОбъекта(ЭтотОбъект, МассивПодписей,
		Новый ОписаниеОповещения("ПроверитьЭПЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЭПЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не Результат Тогда
		Возврат;
	КонецЕсли;
	
	ВыводитьПредупреждение = Истина;
	
	// Обработка ошибки при подписании не сохраненной резолюции.
	//Если Не ДанныеЭП.ПодписьВерна
	//	И (
	//		ДанныеЭП.ТекстОшибкиПроверкиПодписи = "Хеш-значение неправильное."
	//		ИЛИ ДанныеЭП.ТекстОшибкиПроверкиПодписи = "Ошибка интерфейса модуля криптографии. Неверная подпись."
	//	)
	//	И Не ЗначениеЗаполнено(Объект.Источник) Тогда
	//	
	//	ПараметрыФормы = Новый Структура();
	//	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Ошибка проверки подписи'"));
	//	ПараметрыФормы.Вставить("ТекстСообщения",
	//		НСтр("ru = 'При проверке подписи произошла ошибка.
	//			  |Удалите текущую подпись и подпишите резолюцию еще раз.'"));
	//	ОткрытьФорму("ОбщаяФорма.Сообщение", ПараметрыФормы, ЭтаФорма);
	//	ВыводитьПредупреждение = Ложь;
	//	
	//КонецЕсли;
	
	Если ВыводитьПредупреждение Тогда
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Результат проверки подписи: %1'"),
			ДанныеЭП.Статус);
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЭП(Команда)

	Если ЗначениеЗаполнено(Объект.Источник) Тогда
		ТекстПредупреждения = НСтр("ru = 'Нельзя удалить подпись для резолюции, добавленной при выполнении процесса ""Рассмотрение""!'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		Возврат;
	КонецЕсли;	
	
	УдалитьЭПНаСервере();
	
	Оповестить("Запись_Резолюции", Объект.Документ);

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("Закрыть", Истина);
	
	Если Записать(ПараметрыЗаписи) Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоШаблону(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершениеВставкиШаблонаТекста", ЭтотОбъект);
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОбластьПрименения", 
		ПредопределенноеЗначение("Перечисление.ОбластиПримененияШаблоновТекстов.Резолюции"));
		
	ОткрытьФорму("Справочник.ШаблоныТекстов.Форма.ФормаВыбораШаблонаТекста",
		ПараметрыФормы,
		ЭтаФорма,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеВставкиШаблонаТекста(ШаблонТекста, Параметры) Экспорт
	
	Если ШаблонТекста = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтаФорма.ТекущийЭлемент <> Элементы.ТекстРезолюции Тогда
		Элементы.ТекстРезолюции.ВыделенныйТекст = Элементы.ТекстРезолюции.ВыделенныйТекст + ШаблонТекста;
		ЭтаФорма.ТекущийЭлемент = Элементы.ТекстРезолюции;
	Иначе
		Элементы.ТекстРезолюции.ВыделенныйТекст = ШаблонТекста;
	КонецЕсли;
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЭлементыДляСохранения()
	
	СохраняемыеЭлементы = Новый Структура("АвторРезолюции", Объект.АвторРезолюции);
	Возврат СохранениеВводимыхЗначений.СформироватьТаблицуСохраняемыхЭлементов(СохраняемыеЭлементы);
	
КонецФункции

&НаСервере
Процедура УстановитьВидимость()
	
	Элементы.Источник.Видимость = ЗначениеЗаполнено(Объект.Источник);
	Элементы.СтатусПроверкиЭП.Видимость = Объект.Подписана;

	Элементы.ВнесРезолюцию.Видимость = Объект.АвторРезолюции <> Объект.ВнесРезолюцию;
	
	Если Объект.Подписана Тогда
		ПрочитатьЭП();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность()
	
	ЭтаФорма.ТолькоПросмотр = Ложь;
	
	Если Объект.Подписана Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;
		Возврат;
	КонецЕсли;	
	
	Если РольДоступна("ПолныеПрава") Тогда 
		Возврат;
	КонецЕсли;	
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Если Не ТекущийПользователь = Объект.АвторРезолюции
		И Не ТекущийПользователь = Объект.ВнесРезолюцию Тогда 
		ЭтаФорма.ТолькоПросмотр = Истина;
		Возврат;
	КонецЕсли;	
	
	Элементы.ТекстРезолюции.ТолькоПросмотр = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьКоманд()
	
	Элементы.ПодписатьЭП.Доступность = НЕ Объект.Подписана;
	Элементы.ОткрытьЭП.Доступность = Объект.Подписана;
	Элементы.ПроверитьЭП.Доступность = Объект.Подписана;
	Элементы.УдалитьЭП.Доступность = Объект.Подписана;
	
КонецПроцедуры

#Область РаботаСЭлектроннойПодписью

&НаСервере
Процедура ПрочитатьЭП()
	
	ЭП = РаботаСЭП.ПолучитьЭлектроннуюПодпись(Объект.Ссылка);
	Резолюция = Новый Структура("Подписана, УстановившийПодпись, ДатаПодписи, ДатаПроверкиПодписи, ПодписьВерна,
		|ТекстОшибкиПроверки");
	ДанныеЭП = РаботаСЭП.ЗаполнитьДанныеПодписиОбъекта(Объект.Ссылка, УникальныйИдентификатор);
	ЗаполнитьЗначенияСвойств(Резолюция, Объект);
	ЗаполнитьЗначенияСвойств(Резолюция, ЭП);
	СтатусПроверкиЭП = РаботаСРезолюциямиКлиентСервер.ПолучитьИнформациюОбЭПРезолюции(Резолюция);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЭП(ПараметрыЗаписи = Неопределено)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	ДоступНаПодписание = (Объект.ВнесРезолюцию = ТекущийПользователь) ИЛИ (Объект.АвторРезолюции = ТекущийПользователь);
	Если НЕ ДоступНаПодписание Тогда
		ТекстПредупреждения = НСтр("ru = 'Подписать резолюцию может только автор или пользователь, который ее внес.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	МассивДанныхДляЗанесенияВРегистр = Новый Массив;
	МассивАдресов = Новый Массив;
	
	Если Объект.Ссылка.Пустая() Тогда
		ПодписываемыйОбъект = РаботаСРезолюциями.ПолучитьСтруктуруКлючевыхРеквизитовРезолюции();
		ЗаполнитьЗначенияСвойств(ПодписываемыйОбъект, Объект);
		ЗаголовокФормыВыбораСертификата = РаботаСРезолюциямиКлиентСервер.ПолучитьНаименованиеРезолюции(ПодписываемыйОбъект.Документ);
	Иначе
		ПодписываемыйОбъект = Объект.Ссылка;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрыЗаписи) Тогда
		ПараметрыЗаписи = Новый Структура;
	КонецЕсли;
	ОписаниеОповещения = Новый ОписаниеОповещения("СозданиеЭПЗавершение", ЭтотОбъект, ПараметрыЗаписи);
	
	РаботаСЭПКлиент.Подписать(ПодписываемыйОбъект, УникальныйИдентификатор, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СозданиеЭПЗавершение(Результат, ПараметрыЗаписи) Экспорт
	
	Если Не Результат.Успех Тогда
		Возврат;
	КонецЕсли;
	
	МассивДанныхДляЗанесенияВРегистр = Новый Массив;
	МассивАдресов = Новый Массив;
	
	Для Каждого Данные Из Результат.НаборДанных Цикл
		Если Не Данные.Свойство("СвойстваПодписи") Тогда
			Возврат;
		КонецЕсли;
		МассивДанныхДляЗанесенияВРегистр.Добавить(Данные.СвойстваПодписи);
	КонецЦикла;
	
	ДанныеЭП = Новый Структура;
	ДанныеЭП.Вставить("МассивДанныхДляЗанесенияВРегистр", МассивДанныхДляЗанесенияВРегистр);
	ДанныеЭП.Вставить("МассивАдресов", МассивАдресов);
	
	ПодписьУстановлена = Истина;
	Объект.Подписана = ПодписьУстановлена;
	
	Если Записать(ПараметрыЗаписи) И ПараметрыЗаписи.Свойство("Закрыть") Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодписатьЭПНаСервере(МассивДанныхДляЗанесенияВРегистр, МассивАдресов)
	
	ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка, , УникальныйИдентификатор);
	
	Для Каждого Данные Из МассивДанныхДляЗанесенияВРегистр Цикл
		
		РаботаСЭП.ЗанестиИнформациюОПодписи(Объект.Ссылка, Данные);
		
	КонецЦикла;
	
	РазблокироватьДанныеДляРедактирования(Объект.Ссылка, УникальныйИдентификатор);
	
	Для Каждого АдресФайла Из МассивАдресов Цикл
		Если ЭтоАдресВременногоХранилища(АдресФайла) Тогда
			УдалитьИзВременногоХранилища(АдресФайла);
		КонецЕсли;
	КонецЦикла;
	
	УстановитьДоступность();
	УстановитьДоступностьКоманд();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьЭПНаСервере()
	
	Если Не ПользователиСерверПовтИсп.ЭтоПолноправныйПользовательИБ() Тогда 
		Если ДанныеЭП.УстановившийПодпись <> Пользователи.ТекущийПользователь() Тогда
			ВызватьИсключение НСтр("ru = 'У вас нет прав на удаление подписи.'");
		КонецЕсли;
		
		Если ТипЗнч(ПодписыватьРезолюциюЭП) = Тип("Булево") И ПодписыватьРезолюциюЭП Тогда
			ВызватьИсключение НСтр("ru = 'Нельзя удалить подпись для резолюции документа, в настройках вида которого установлена обязательность подписания резолюций!'");
		КонецЕсли;
	КонецЕсли; 
	
	ЭП = РаботаСЭП.ПолучитьЭлектроннуюПодпись(Объект.Ссылка);
	Если ЭП = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Подпись не найдена.'");
	КонецЕсли;
	ЭП.Удалить();
	
	Резолюция = Объект.Ссылка.ПолучитьОбъект();
	Резолюция.Подписана = Ложь;
	Резолюция.Записать();
	
	ЗначениеВРеквизитФормы(Резолюция, "Объект");
	
	УстановитьВидимость();
	УстановитьДоступность();
	УстановитьДоступностьКоманд();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти