﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ДанныеЛицензии = Неопределено;
	Если Параметры.Свойство("ДанныеЛицензии", ДанныеЛицензии)
		И ТипЗнч(ДанныеЛицензии) = Тип("Структура") Тогда 
		
		ДанныеЛицензии.Свойство("ДатаВыдачи", ДатаВыдачи);
		ДанныеЛицензии.Свойство("ДатаНачалаДействия", ДатаНачалаДействия);
		ДанныеЛицензии.Свойство("ДатаОкончанияДействия", ДатаОкончанияДействия);
		ДанныеЛицензии.Свойство("НомерДокумента", НомерДокумента);
		ДанныеЛицензии.Свойство("Орган", Орган);
		ДанныеЛицензии.Свойство("ИмяФайла", ИмяФайла);
		ДанныеЛицензии.Свойство("ПрисоединенныйФайл", ПрисоединенныйФайл);
	КонецЕсли;
	
	Параметры.Свойство("Уведомление", Уведомление);
	
	Если Параметры.Свойство("ЗаголовокФормы") Тогда 
		Параметры.Свойство("ЗаголовокФормы", Заголовок);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяФайла) Тогда 
		Элементы.ЗначокУдалить.Видимость = Истина;
		Элементы.Добавить.Заголовок = ИмяФайла;
	Иначе 
		Элементы.ЗначокУдалить.Видимость = Ложь;
		Элементы.Добавить.Заголовок = "Добавить скан-копию";
	КонецЕсли;
	
	Если Параметры.Свойство("РедактируемыйУИД") Тогда 
		РедактируемыйУИД = Параметры.РедактируемыйУИД;
	КонецЕсли;
	
	Элементы.ГруппаСканОбраз.Видимость = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами");
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	ПараметрыЗакрытия = СформироватьРезультатДляЗакрытия();
	Закрыть(ПараметрыЗакрытия);
КонецПроцедуры

&НаКлиенте
Процедура ЗначокУдалитьНажатие(Элемент)
	Элементы.ЗначокУдалить.Видимость = Ложь;
	Элементы.Добавить.Заголовок = "Добавить скан-копию";
	ИмяФайла = "";
	ЗначокУдалитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗначокУдалитьНаСервере()
	Попытка
		ПрисоединенныйФайлОбъект = ПрисоединенныйФайл.ПолучитьОбъект();
		ПрисоединенныйФайлОбъект.ПометкаУдаления = Истина;
		ПрисоединенныйФайлОбъект.Записать();
	Исключение
		ЗаписьЖурналаРегистрации("Не удалось установить пометку удаления присоединенного файла", УровеньЖурналаРегистрации.Предупреждение, Уведомление);
	КонецПопытки;
	ПрисоединенныйФайл = Неопределено;
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Функция СформироватьРезультатДляЗакрытия()
	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("ДатаВыдачи", ДатаВыдачи);
	СтруктураРезультата.Вставить("ДатаНачалаДействия", ДатаНачалаДействия);
	СтруктураРезультата.Вставить("ДатаОкончанияДействия", ДатаОкончанияДействия);
	СтруктураРезультата.Вставить("НомерДокумента", НомерДокумента);
	СтруктураРезультата.Вставить("Орган", Орган);
	СтруктураРезультата.Вставить("ИмяФайла", ИмяФайла);
	СтруктураРезультата.Вставить("ПрисоединенныйФайл", ПрисоединенныйФайл);
	
	Результат = Новый Структура;
	Если ЗначениеЗаполнено(РедактируемыйУИД) Тогда
		Результат.Вставить("РедактируемыйУИД", РедактируемыйУИД);
		УИД = РедактируемыйУИД;
	Иначе
		УИД = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	Результат.Вставить("УИД", УИД);
	Результат.Вставить("Адрес", ПоместитьВоВременноеХранилище(СтруктураРезультата, УИД));
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ДобавитьНажатие(Элемент)
	Если Не ЗначениеЗаполнено(ПрисоединенныйФайл) Тогда 
		ДобавитьФайл();
	Иначе
		СохранитьНаДискФайл();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл()
	
	АдресФайла  = "";
	ВыбИмяФайла = "";
	
	Оп = Новый ОписаниеОповещения("ДобавитьФайлЗавершение", ЭтотОбъект);
	
	Попытка
		НачатьПомещениеФайла(Оп, АдресФайла, ВыбИмяФайла, Истина, УникальныйИдентификатор);
	Исключение
		ШаблонСообщения = НСтр("ru = 'При загрузке файла возникла ошибка.
									 |%1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ПоказатьПредупреждение(, ТекстСообщения, , НСтр("ru = 'Ошибка'"));
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлЗавершение(Результат, АдресФайла, ВыбИмяФайла, Парам) Экспорт
	
	Если НЕ Результат Тогда
		Возврат;
	КонецЕсли;
	
	Каталог = "";
	СтрокаПоиска = ВыбИмяФайла;
	
	Пока СтрДлина(СтрокаПоиска) > 0 Цикл
		Если Прав(СтрокаПоиска, 1) = "\" ИЛИ Прав(СтрокаПоиска, 1) = "/" Тогда
			Каталог = Лев(СтрокаПоиска, СтрДлина(СтрокаПоиска));
			Прервать;
		Иначе
			СтрокаПоиска = Лев(СтрокаПоиска, СтрДлина(СтрокаПоиска) - 1);
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		ЗаполнитьСтруктуруДанныхФайла(АдресФайла, ВыбИмяФайла, Каталог);
	Исключение
		ШаблонСообщения = НСтр("ru = 'При загрузке файла возникла ошибка.
									 |%1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ПоказатьПредупреждение(, ТекстСообщения, , НСтр("ru = 'Ошибка'"));
		Возврат;
	КонецПопытки;
	
	Элементы.ЗначокУдалить.Видимость = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруДанныхФайла(АдресФайла, ПолноеИмяФайла, Каталог)
	МодульРаботаСФайлами = ОбщегоНазначения.ОбщийМодуль("РаботаСФайлами");
	ИмяФайла = СтрЗаменить(ПолноеИмяФайла, Каталог, "");
	ИмяБезРасширения = Лев(ИмяФайла, СтрНайти(ИмяФайла, ".", НаправлениеПоиска.СКонца) - 1);
	ПараметрыФайла = Новый Структура;
	ПараметрыФайла.Вставить("ВладелецФайлов", Уведомление);
	ПараметрыФайла.Вставить("Автор", Неопределено);
	ПараметрыФайла.Вставить("ИмяБезРасширения", СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", ""));
	ПараметрыФайла.Вставить("РасширениеБезТочки", Неопределено);
	ПараметрыФайла.Вставить("ВремяИзменения", Неопределено);
	ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", Неопределено);
	ПрисоединенныйФайл = МодульРаботаСФайлами.ДобавитьФайл(ПараметрыФайла, АдресФайла, , "Файл создан автоматически из формы уведомления, редактирование запрещено.");
	Модифицированность = Истина;
	Элементы.Добавить.Заголовок = ИмяФайла;
КонецПроцедуры

&НаСервере
Функция АдресДДФайла()
	МодульРаботаСФайлами = ОбщегоНазначения.ОбщийМодуль("РаботаСФайлами");
	Возврат ПоместитьВоВременноеХранилище(МодульРаботаСФайлами.ДвоичныеДанныеФайла(ПрисоединенныйФайл));
КонецФункции

&НаКлиенте
Процедура СохранитьНаДискФайл()
	Попытка
		Если Не ЗначениеЗаполнено(ПрисоединенныйФайл) Тогда 
			Возврат;
		КонецЕсли;
		АдресДД = АдресДДФайла();
		
		ПолучитьФайл(АдресДД, ИмяФайла, Истина);
		
	Исключение
		ШаблонСообщения = НСтр("ru = 'При выгрузке файла возникла ошибка.
									 |%1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ПоказатьПредупреждение(, ТекстСообщения, , НСтр("ru = 'Ошибка'"));
		Возврат;
	КонецПопытки;
КонецПроцедуры