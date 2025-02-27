﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнформационнаяБазаФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	ВидимостьКнопок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ФоновоеВыполнениеЗавершено_УдалениеОбъектов.УдалитьПомеченныеОбъекты" Тогда
		ОбработатьРезультатУдаления(Источник);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СписокМетаданных

// Обработчик события "при измении" поля "Пометка"
// Вызывает рекурсивную функцию, устанавливающую зависимые флажки пометок
// в родительских и дочерних элементах
//
&НаКлиенте
Процедура СписокМетаданныхПометкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокМетаданных.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПометкуВСписке(ТекущиеДанные, ТекущиеДанные.Пометка, Истина);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СписокПомеченныхНаУдаление

// Обработчик события "при измении" поля "Пометка"
// Вызывает рекурсивную функцию, устанавливающую зависимые флажки пометок
// в родительских и дочерних элементах
//
&НаКлиенте
Процедура ПометкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокПомеченныхНаУдаление.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПометкуВСписке(ТекущиеДанные, ТекущиеДанные.Пометка, Истина);
	
КонецПроцедуры

// Обработчик события "выбор" строки дерева СписокПомеченныхНаУдаление
// Пытается открыть выбранное значение
//
&НаКлиенте
Процедура СписокПомеченныхНаУдалениеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.СписокПомеченныхНаУдаление.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ПолучитьЭлементы().Количество() = 0 Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, ТекущиеДанные.Значение);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ДеревоОставшихсяОбъектов

// Обработчик события "выбор" строки дерева ДеревоОставшихсяОбъектов
// Пытается открыть выбранное значение
//
&НаКлиенте
Процедура ДеревоОставшихсяОбъектовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДеревоОставшихсяОбъектов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено ИЛИ ТипЗнч(ТекущиеДанные.Значение) = Тип("Строка") Тогда
		Возврат;
	КонецЕсли;
	
	// это строка отображает объект, из-за которого не удалось удалить помеченный и выбранный
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, ТекущиеДанные.Значение);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура УдалитьАвтоматически(Команда)
	
	РежимУдаления = "Полный";
	ВыполнитьУдаление();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВыборочно(Команда)
	
	РежимУдаления = "Выборочный";
	ВыполнитьДалее();

КонецПроцедуры

// Обработчик нажатия на кнопку "Далее" командной панели формы
// 
&НаКлиенте
Процедура ВыполнитьДалее()
	
	ТекущаяСтраница = Элементы.СтраницыФормы.ТекущаяСтраница;
	
	Если ТекущаяСтраница = Элементы.ВыборРежимаУдаления Тогда
		
		ЗаполнитьСписокМетаданных();
		
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ВыборТиповДляУдаления;
		ВидимостьКнопок();
		
	ИначеЕсли ТекущаяСтраница = Элементы.ВыборТиповДляУдаления Тогда
		
		Состояние(НСтр("ru = 'Выполняется поиск помеченных на удаление объектов'"));
		
		ЗаполнениеДереваПомеченныхНаУдаление();
		
		Если КоличествоУровнейПомеченныхНаУдаление = 0 Тогда
			СообщениеОбОшибке = НСтр("ru = 'Не найдено ни одного объекта, помеченного на удаление'");
			ПоказатьПредупреждение(, СообщениеОбОшибке);
			Возврат;
		ИначеЕсли КоличествоУровнейПомеченныхНаУдаление = 1 Тогда
			Для Каждого Элемент Из СписокПомеченныхНаУдаление.ПолучитьЭлементы() Цикл
				Идентификатор = Элемент.ПолучитьИдентификатор();
				Элементы.СписокПомеченныхНаУдаление.Развернуть(Идентификатор, Ложь);
			КонецЦикла;
		КонецЕсли;
		
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ПомеченныеНаУдаление;
		ВидимостьКнопок();
	КонецЕсли;
	
КонецПроцедуры

// Обработчик нажатия на кнопку "Назад" командной панели формы
//
&НаКлиенте
Процедура ВыполнитьНазад()
	
	ТекущаяСтраница = Элементы.СтраницыФормы.ТекущаяСтраница;
	
	Если ТекущаяСтраница = Элементы.ВыборТиповДляУдаления Тогда
		
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ВыборРежимаУдаления;
		ВидимостьКнопок();
		
	ИначеЕсли ТекущаяСтраница = Элементы.ПомеченныеНаУдаление Тогда
		
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ВыборТиповДляУдаления;
		ВидимостьКнопок();
		
	ИначеЕсли ТекущаяСтраница = Элементы.ПричиныНевозможностиУдаления Тогда
		
		Если РежимУдаления = "Полный" Тогда
			Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ВыборРежимаУдаления;
		Иначе
			Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ПомеченныеНаУдаление;
		КонецЕсли;
		ВидимостьКнопок();
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик нажатия на кнопку "Удалить" командной панели формы
//
&НаКлиенте
Процедура ВыполнитьУдаление()
	
	Перем ТипыУдаленныхОбъектов;
	
	Если РежимУдаления = "Полный" Тогда
		Состояние(НСтр("ru = 'Выполняется поиск и удаление помеченных объектов'"));
	Иначе
		Состояние(НСтр("ru = 'Выполняется удаление выбранных объектов'"));
	КонецЕсли;
	
	СообщениеОбОшибке = "";
	ИдентификаторФЗ = Новый УникальныйИдентификатор;
	АдресХранилищаРезультата = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	КоличествоУдаляемых = 0;
	
	ИнициироватьУдалениеВыбранныхНаСервере(ИдентификаторФЗ,
		АдресХранилищаРезультата, СообщениеОбОшибке);
		
	Если КоличествоУдаляемых = 0 Тогда
		Если РежимУдаления = "Полный" Тогда
			СообщениеОбОшибке = НСтр("ru = 'Не найдено ни одного помеченного объекта'");
		Иначе
			СообщениеОбОшибке = НСтр("ru = 'Не выбраны объекты для удаления'");
		КонецЕсли;
		ПоказатьПредупреждение(, СообщениеОбОшибке);
		Возврат;
	КонецЕсли;
	
	Если ИнформационнаяБазаФайловая Тогда
		ОбработатьРезультатУдаления(Неопределено);
	Иначе
		// Форма, отображающая процент выполнения
		ПараметрыФормы = Новый Структура("ИдентификаторФЗ, ЗаголовокФормы");
		ПараметрыФормы.Вставить("ИдентификаторФЗ", ИдентификаторФЗ);
		ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Удаление объектов'"));
		ПараметрыФормы.Вставить("ВыполнитьФЗ", Ложь);
		ПараметрыФормы.Вставить("ИмяФункции", "УдалениеОбъектов.УдалитьПомеченныеОбъекты");
		ПараметрыФормы.Вставить("МаксимальныйПроцент", 98);
		ОткрытьФорму("ОбщаяФорма.ВыполнениеДлительнойОперации", ПараметрыФормы);
	КонецЕсли;

КонецПроцедуры	

&НаКлиенте
Процедура КомандаСписокМетаданныхПометкаУстановитьВсе(Команда)
	
	ЭлементыСписка = СписокМетаданных.ПолучитьЭлементы();
	Для Каждого Элемент Из ЭлементыСписка Цикл
		Элемент.Пометка = Истина;
		УстановитьПометкуВСписке(Элемент, Истина, Ложь);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСписокМетаданныхПометкаСнятьВсе(Команда)
	
	ЭлементыСписка = СписокМетаданных.ПолучитьЭлементы();
	Для Каждого Элемент Из ЭлементыСписка Цикл
		Элемент.Пометка = Ложь;
		УстановитьПометкуВСписке(Элемент, Ложь, Ложь);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОставшихсяПоказатьСсылкиНаТекущий(Команда)
	
	ИдентификаторТекущейСтроки = Элементы.ДеревоОставшихсяОбъектов.ТекущаяСтрока;
	СсылкаДляПоиска = Элементы.ДеревоОставшихсяОбъектов.ТекущиеДанные.Значение;
	
	Если СсылкаДляПоиска = Неопределено // Например, значение константы
		 Или ТипЗнч(СсылкаДляПоиска) = Тип("Строка") Тогда // Ключ записи регистра
		Возврат
	КонецЕсли;
	
	ДеревоОставшихсяПоказатьСсылкиНаТекущийНаСервере(ИдентификаторТекущейСтроки, СсылкаДляПоиска);
	Элементы.ДеревоОставшихсяОбъектов.Развернуть(ИдентификаторТекущейСтроки);
	
КонецПроцедуры

// Обработчик нажания на кнопку "установить все" командной панели списка
// дерева СписокПомеченныхНаУдаление.
// Устанавливает пометку всем найденным объектам
//
&НаКлиенте
Процедура КомандаСписокПомеченныхУстановитьВсе()
	ЭлементыСписка = СписокПомеченныхНаУдаление.ПолучитьЭлементы();
	Для Каждого Элемент Из ЭлементыСписка Цикл
		УстановитьПометкуВСписке(Элемент, Истина, Истина);
	КонецЦикла;
КонецПроцедуры

// Обработчик нажания на кнопку "снять все" командной панели списка
// дерева СписокПомеченныхНаУдаление.
// Снимает пометку у всех найденных объектов
//
&НаКлиенте
Процедура КомандаСписокПомеченныхСнятьВсе()
	ЭлементыСписка = СписокПомеченныхНаУдаление.ПолучитьЭлементы();
	Для Каждого Элемент Из ЭлементыСписка Цикл
		УстановитьПометкуВСписке(Элемент, Ложь, Истина);
	КонецЦикла;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбработатьРезультатУдаления(ФормаДлительнойОперации)
	
	ТипыУдаленныхОбъектов = Неопределено;
	СообщениеОбОшибке = "";
	
	Если ОбработатьРезультатУдаленияНаСервере(АдресХранилищаРезультата,
			ТипыУдаленныхОбъектов, СообщениеОбОшибке) Тогда
		Если ФормаДлительнойОперации <> Неопределено Тогда
			ФормаДлительнойОперации.Процент = 100;
		КонецЕсли;
		Для Каждого ТипУдаленногоОбъекта Из ТипыУдаленныхОбъектов Цикл
			ОповеститьОбИзменении(ТипУдаленногоОбъекта);
		КонецЦикла;
	Иначе
		Если ФормаДлительнойОперации <> Неопределено Тогда
			ФормаДлительнойОперации.Закрыть();
		КонецЕсли;
		Если Не ЗначениеЗаполнено(СообщениеОбОшибке) Тогда
			СообщениеОбОшибке = НСтр("ru = 'Не удалось выполнить операцию.
				|Подробности см. в журнале регистрации.'");
		КонецЕсли;
		ПоказатьПредупреждение(, СообщениеОбОшибке);
		Возврат;
	КонецЕсли;
	
	Если ФормаДлительнойОперации <> Неопределено Тогда
		ФормаДлительнойОперации.Закрыть();
	КонецЕсли;
	
	ОбновитьДеревоПомеченных = Истина;
	Если КоличествоНеУдаленныхОбъектов = 0 Тогда
		Если УдаленныхОбъектов = 0 Тогда
			Текст = НСтр("ru = 'Не помечено на удаление ни одного объекта. Удаление объектов не выполнялось'");
			ОбновитьДеревоПомеченных = Ложь;
		Иначе
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			             НСтр("ru = 'Удаление помеченных объектов успешно завершено.
			                        |Удалено объектов: %1.'"),
			             УдаленныхОбъектов);
		КонецЕсли;
	Иначе
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ПричиныНевозможностиУдаления;
		Для Каждого Элемент Из ДеревоОставшихсяОбъектов.ПолучитьЭлементы() Цикл
			Идентификатор = Элемент.ПолучитьИдентификатор();
			Элементы.ДеревоОставшихсяОбъектов.Развернуть(Идентификатор, Ложь);
		КонецЦикла;
		ВидимостьКнопок();
		Текст = СтрокаРезультатов;
	КонецЕсли;
	
	ОписаниеОповещения = 
		Новый ОписаниеОповещения(
			"ОбработатьРезультатУдаленияПродолжение",
			ЭтотОбъект,
			ОбновитьДеревоПомеченных);
			
	ПоказатьПредупреждение(ОписаниеОповещения, Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатУдаленияПродолжение(ОбновитьДеревоПомеченных) Экспорт
	
	Если ОбновитьДеревоПомеченных Тогда
		ЗаполнениеДереваПомеченныхНаУдаление();
		
		Если КоличествоУровнейПомеченныхНаУдаление = 1 Тогда 
			Для Каждого Элемент Из СписокПомеченныхНаУдаление.ПолучитьЭлементы() Цикл
				Идентификатор = Элемент.ПолучитьИдентификатор();
				Элементы.СписокПомеченныхНаУдаление.Развернуть(Идентификатор, Ложь);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДеревоОставшихсяПоказатьСсылкиНаТекущийНаСервере(ИдентификаторТекущейСтроки, СсылкаДляПоиска)
	
	ТекущаяСтрока = ДеревоОставшихсяОбъектов.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
	КоллекцияПодчиненныхСтрок = ТекущаяСтрока.ПолучитьЭлементы();
	КоллекцияПодчиненныхСтрок.Очистить();
		
	МассивДляПоиска = Новый Массив;
	МассивДляПоиска.Добавить(СсылкаДляПоиска);
	
	ТаблицаНайденныхСсылок = НайтиПоСсылкам(МассивДляПоиска);
	ДеревоОбъектов = ДанныеФормыВЗначение(ДеревоОставшихсяОбъектов, Тип("ДеревоЗначений"));
	Для Каждого Найденный из ТаблицаНайденныхСсылок Цикл
		
		Ссылающийся = Найденный[1];
		ОбъектМетаданныхСсылающегося = Найденный[2].Представление();
		
		НоваяСтрока = КоллекцияПодчиненныхСтрок.Добавить();
		НоваяСтрока.Значение = Ссылающийся;
		НоваяСтрока.Представление = Строка(Ссылающийся) + " - " + ОбъектМетаданныхСсылающегося;
		
		// Определение номера картинки выводимой строки
		СсылающийсяПрепятствуетУдалению = Истина;
		Если Найти(Строка(ТипЗнч(Ссылающийся)), "Регистр сведений ключ записи") > 0 Тогда
			// Связанные объекты и регистры сведений не препятствуют удалению
			СсылающийсяПрепятствуетУдалению = Ложь;
		КонецЕсли;
		
		Если СсылающийсяПрепятствуетУдалению Тогда
			МетаданныеСвязанныхОбъектов = УдалениеОбъектовПереопределяемый.ПолучитьТипыСвязанныхОбъектов();
			Если МетаданныеСвязанныхОбъектов.Найти(Ссылающийся.Метаданные()) <> Неопределено Тогда
				// Связанные объекты и регистры сведений не препятствуют удалению
				СсылающийсяПрепятствуетУдалению = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		Если СсылающийсяПрепятствуетУдалению Тогда
			// Поиск по элементам дерева оставшихся объектов
			Для Каждого ЭлементМетаданных Из ДеревоОбъектов.Строки Цикл
				Если ЭлементМетаданных.Строки.Найти(Ссылающийся, "Значение", Ложь) <> Неопределено Тогда
					// Удаляемые объекты не препятствуют удалению
					СсылающийсяПрепятствуетУдалению = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
			
		Если СсылающийсяПрепятствуетУдалению Тогда
			НоваяСтрока.НомерКартинки = 1;
		Иначе
			НоваяСтрока.НомерКартинки = 2;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

/////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры

// Изменяет доступность кнопок на форме в зависимости от
// текущей страницы и состояния реквизитов формы
//
&НаСервере
Процедура ВидимостьКнопок()
	
	ТекущаяСтраница = Элементы.СтраницыФормы.ТекущаяСтраница;
	
	ЭтоВыборРежимаУдаления = ТекущаяСтраница = Элементы.ВыборРежимаУдаления;
	Элементы.Закрыть.Видимость = Не ЭтоВыборРежимаУдаления;
	Элементы.Справка.Видимость = Не ЭтоВыборРежимаУдаления;
	
	Если ЭтоВыборРежимаУдаления Тогда
		Элементы.КомандаНазад.Видимость   = Ложь;
		Элементы.КомандаДалее.Видимость   = Ложь;
		Элементы.КомандаУдалить.Видимость = Ложь;
		ТекущийЭлемент = Элементы.УдалитьВыборочно;
	ИначеЕсли ТекущаяСтраница = Элементы.ВыборТиповДляУдаления Тогда
		Элементы.КомандаНазад.Видимость   = Истина;
		Элементы.КомандаДалее.Видимость   = Истина;
		Элементы.КомандаУдалить.Видимость = Ложь;
	ИначеЕсли ТекущаяСтраница = Элементы.ПомеченныеНаУдаление Тогда
		Элементы.КомандаНазад.Видимость   = Истина;
		Элементы.КомандаДалее.Видимость   = Ложь;
		Элементы.КомандаУдалить.Видимость = Истина;
	ИначеЕсли ТекущаяСтраница = Элементы.ПричиныНевозможностиУдаления Тогда
		Элементы.КомандаНазад.Видимость   = Истина;
		Элементы.КомандаДалее.Видимость   = Ложь;
		Элементы.КомандаУдалить.Видимость = Ложь;
	КонецЕсли;
	
	Если ТекущаяСтраница = Элементы.ПомеченныеНаУдаление Тогда
		Элементы.КомандаУдалить.КнопкаПоУмолчанию = Истина;
	Иначе
		Элементы.КомандаДалее.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает ветвь дерева в ветви СтрокиДерева по значению Значение
// Если ветвь не найдена - создается новая
//
&НаСервереБезКонтекста
Функция НайтиИлиДобавитьВетвьДерева(СтрокиДерева, Значение, Представление, Пометка)
	
	// Попытка найти существующую ветвь в СтрокиДерева без вложенных
	Ветвь = СтрокиДерева.Найти(Значение, "Значение", Ложь);
	
	Если Ветвь = Неопределено Тогда
		// Такой ветки нет, создадим новую
		Ветвь = СтрокиДерева.Добавить();
		Ветвь.Значение      = Значение;
		Ветвь.Представление = Представление;
		Ветвь.Пометка       = Пометка;
	КонецЕсли;
	
	Возврат Ветвь;
	
КонецФункции

&НаСервереБезКонтекста
Функция НайтиИлиДобавитьВетвьДереваСКартинкой(СтрокиДерева, Значение, Представление, НомерКартинки)
	// Попытка найти существующую ветвь в СтрокиДерева без вложенных
	Ветвь = СтрокиДерева.Найти(Значение, "Значение", Ложь);
	Если Ветвь = Неопределено Тогда
		// Такой ветки нет, создадим новую
		Ветвь = СтрокиДерева.Добавить();
		Ветвь.Значение      = Значение;
		Ветвь.Представление = Представление;
		Ветвь.НомерКартинки = НомерКартинки;
	КонецЕсли;

	Возврат Ветвь;
КонецФункции

// Заполняет дерево объектов помеченных на удаление
//
&НаСервере
Процедура ЗаполнениеДереваПомеченныхНаУдаление()
	
	// Заполнение дерева помеченных на удаление
	ДеревоПомеченных = РеквизитФормыВЗначение("СписокПомеченныхНаУдаление");
	ДеревоПомеченных.Строки.Очистить();
	
	ДеревоМетаданных = РеквизитФормыВЗначение("СписокМетаданных");
	
	// обработка помеченных
	ИскатьВсеСсылки = Истина;
	Если РежимУдаления = "Выборочный" Тогда
		Для Каждого ГруппаМетаданных Из ДеревоМетаданных.Строки Цикл
			Если Не ГруппаМетаданных.Пометка Тогда
				ИскатьВсеСсылки = Ложь;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	МетаданныеДляПоискаСсылок = Неопределено;
	Если Не ИскатьВсеСсылки Тогда
		
		МетаданныеДляПоискаСсылок = Новый Массив;
		
		Для Каждого ГруппаМетаданных из ДеревоМетаданных.Строки Цикл
			Для Каждого ЭлементМетаданных из ГруппаМетаданных.Строки Цикл
				Если ЭлементМетаданных.Пометка Тогда
					МетаданныеДляПоискаСсылок.Добавить(ЭлементМетаданных.ПолноеИмя);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		Если МетаданныеДляПоискаСсылок.Количество() = 0 Тогда
			КоличествоУровнейПомеченныхНаУдаление = 0;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	МассивПомеченных = ПолучитьПомеченныеНаУдаление(МетаданныеДляПоискаСсылок);
	
	ДеревоПомеченных.Колонки.Добавить("Порядок", Новый ОписаниеТипов("Число"));
	
	Для Каждого МассивПомеченныхЭлемент Из МассивПомеченных Цикл
		
		МетаданныеЭлемента = МассивПомеченныхЭлемент.Метаданные();
		ОбъектМетаданныхЗначение = МетаданныеЭлемента.ПолноеИмя();
		ОбъектМетаданныхПредставление = МетаданныеЭлемента.Представление();
		
		ГруппаОбъектаМетаданных = ОбщегоНазначения.ИмяБазовогоТипаПоОбъектуМетаданных(МетаданныеЭлемента);
		
		Если ГруппаОбъектаМетаданных = "Справочники" Тогда
			Порядок = 1;
		ИначеЕсли ГруппаОбъектаМетаданных = "Документы" Тогда
			Порядок = 2;
		ИначеЕсли ГруппаОбъектаМетаданных = "ПланыВидовХарактеристик" Тогда
			ГруппаОбъектаМетаданных = "Планы видов характеристик";
			Порядок = 3;
		ИначеЕсли ГруппаОбъектаМетаданных = "БизнесПроцессы" Тогда
			ГруппаОбъектаМетаданных = "Бизнес-процессы";
			Порядок = 4;
		ИначеЕсли ГруппаОбъектаМетаданных = "Задачи" Тогда
			Порядок = 5;
		ИначеЕсли ГруппаОбъектаМетаданных = "ПланыОбмена" Тогда
			ГруппаОбъектаМетаданных = "Планы обмена";
			Порядок = 6;
		Иначе
			Порядок = 7;
		КонецЕсли;
		
		СтрокаГруппыОбъектовМетаданных = НайтиИлиДобавитьВетвьДерева(ДеревоПомеченных.Строки, 
			ГруппаОбъектаМетаданных, ГруппаОбъектаМетаданных, Ложь);
			
		СтрокаГруппыОбъектовМетаданных.Порядок = Порядок;
		
		СтрокаОбъектаМетаданных = НайтиИлиДобавитьВетвьДерева(СтрокаГруппыОбъектовМетаданных.Строки, 
			ОбъектМетаданныхЗначение, ОбъектМетаданныхПредставление, Ложь);
			
		НайтиИлиДобавитьВетвьДерева(СтрокаОбъектаМетаданных.Строки, МассивПомеченныхЭлемент, 
			Строка(МассивПомеченныхЭлемент) + " - " + ОбъектМетаданныхПредставление, Ложь);
			
	КонецЦикла;
	
	ДеревоПомеченных.Строки.Сортировать("Значение", Истина);
	ДеревоПомеченных.Строки.Сортировать("Порядок", Ложь);
	ДеревоПомеченных.Колонки.Удалить("Порядок");
	
	Для Каждого СтрокаГруппыМетаданных Из ДеревоПомеченных.Строки Цикл
					
		Для Каждого ЭлементДереваМетаданных из ДеревоМетаданных.Строки Цикл
			Если ЭлементДереваМетаданных.Синоним = СтрокаГруппыМетаданных.Значение Тогда
				СтрокаГруппыМетаданных.Картинка = ЭлементДереваМетаданных.Картинка;
				СтрокаГруппыМетаданных.КартинкаОбъекта = ЭлементДереваМетаданных.Строки[0].КартинкаОбъекта;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		КоличествоОбъектовВсего = 0;
		
		Для Каждого СтрокаОбъектаМетаданных Из СтрокаГруппыМетаданных.Строки Цикл
			// создать представление для строк, отображающих ветвь объекта метаданных
			КоличествоОбъектов = СтрокаОбъектаМетаданных.Строки.Количество();
			КоличествоОбъектовВсего = КоличествоОбъектовВсего + КоличествоОбъектов;
			СтрокаОбъектаМетаданных.Картинка = СтрокаГруппыМетаданных.КартинкаОбъекта;
			СтрокаОбъектаМетаданных.Представление = 
				СтрокаОбъектаМетаданных.Представление + " (" + КоличествоОбъектов + ")";
		КонецЦикла;
		
		СтрокаГруппыМетаданных.Представление = 
			СтрокаГруппыМетаданных.Представление + " (" + КоличествоОбъектовВсего + ")";
			
	КонецЦикла;
	
	КоличествоУровнейПомеченныхНаУдаление = ДеревоПомеченных.Строки.Количество();
	
	ЗначениеВРеквизитФормы(ДеревоПомеченных, "СписокПомеченныхНаУдаление");
	
КонецПроцедуры

// Рекурсивная функция, снимающая / устанавливающая пометки
// для зависимых родительских и дочерних элементов
//
&НаКлиенте
Процедура УстановитьПометкуВСписке(Данные, Пометка, ПроверятьРодителя)
	
	// Устанавливаем подчиненным
	ЭлементыСтроки = Данные.ПолучитьЭлементы();
	
	Для Каждого Элемент Из ЭлементыСтроки Цикл
		Элемент.Пометка = Пометка;
		УстановитьПометкуВСписке(Элемент, Пометка, Ложь);
	КонецЦикла;
	
	// Проверяем родителя
	Родитель = Данные.ПолучитьРодителя();
	
	Если ПроверятьРодителя И Родитель <> Неопределено Тогда 
		ПроверитьРодителя(Родитель);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьРодителя(Родитель)
	
	ПометкаРодителя = Истина;
	ЭлементыСтроки = Родитель.ПолучитьЭлементы();
	Для Каждого Элемент Из ЭлементыСтроки Цикл
		Если Не Элемент.Пометка Тогда
			ПометкаРодителя = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Родитель.Пометка = ПометкаРодителя;
	
	// Рекурсивный вызов
	Родитель = Родитель.ПолучитьРодителя();
	Если Родитель <> Неопределено Тогда
		ПроверитьРодителя(Родитель);
	КонецЕсли;
	
КонецПроцедуры

// Производит попытку удаления выбранных объектов
// Объекты, которые не были удалены показываются в отдельной таблице
//
&НаСервере
Процедура ИнициироватьУдалениеВыбранныхНаСервере(
			ИдентификаторФЗ, 
			АдресХранилищаРезультата, 
			СообщениеОбОшибке)
	
	Удаляемые = Новый Массив;
	
	Если РежимУдаления = "Полный" Тогда
		// При полном удалении получаем весь список помеченных на удаление
		Удаляемые = УдалениеОбъектов.ПолучитьПомеченныеНаУдаление();
	Иначе
		// Заполняем массив ссылками на выбранные элементы, помеченные на удаление
		Для Каждого ГруппаСтрокМетаданных Из СписокПомеченныхНаУдаление.ПолучитьЭлементы() Цикл
			Для Каждого СтрокаОбъектаМетаданных Из ГруппаСтрокМетаданных.ПолучитьЭлементы() Цикл
				Для Каждого СтрокаСсылки Из СтрокаОбъектаМетаданных.ПолучитьЭлементы() Цикл
					Если СтрокаСсылки.Пометка Тогда
						Удаляемые.Добавить(СтрокаСсылки.Значение);
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	КоличествоУдаляемых = Удаляемые.Количество();
	Если КоличествоУдаляемых = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Выполняем удаление через фоновое задание
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		УдалениеОбъектов.УдалитьПомеченныеОбъекты(Удаляемые, Неопределено, Неопределено, АдресХранилищаРезультата);
	Иначе
		ПараметрыФункции = Новый Массив;
		ПараметрыФункции.Добавить(Удаляемые);
		ПараметрыФункции.Добавить(Неопределено);
		ПараметрыФункции.Добавить(Неопределено);
		ПараметрыФункции.Добавить(АдресХранилищаРезультата);
		
		ФЗ = ФоновыеЗадания.Выполнить(
			"УдалениеОбъектов.УдалитьПомеченныеОбъекты",
			ПараметрыФункции,
			ИдентификаторФЗ);
	КонецЕсли;		
		
КонецПроцедуры

&НаСервере
Функция ОбработатьРезультатУдаленияНаСервере(
			АдресХранилищаРезультата, 
			ТипыУдаленныхОбъектов,
			СообщениеОбОшибке)
	
	Результат = ПолучитьИзВременногоХранилища(АдресХранилищаРезультата);
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не Результат.Статус Тогда
		СообщениеОбОшибке = Результат.Значение;
		Возврат Ложь;
	КонецЕсли;
	
	КоличествоУдаляемых = Результат.Значение.КоличествоУдаляемых;
	Найденные   = Результат.Значение.Найденные;
	НеУдаленные = Результат.Значение.НеУдаленные;
	ТипыУдаленныхОбъектов = Результат.Значение.ТипыУдаленныхОбъектов;
	
	КоличествоНеУдаленныхОбъектов = НеУдаленные.Количество();
	
	// Создадим таблицу оставшихся (не удаленных) объектов
	ДеревоОставшихсяОбъектов.ПолучитьЭлементы().Очистить();
	Дерево = РеквизитФормыВЗначение("ДеревоОставшихсяОбъектов");
	
	Для Каждого Найденный Из Найденные Цикл
		
		НеУдаленный = Найденный.Ссылка;
		Ссылающийся = Найденный.Данные;
		ОбъектМетаданныхСсылающегося = Метаданные.НайтиПоПолномуИмени(Найденный.Метаданные);
		ТекстОшибки = Найденный.ТекстОшибки;
		ПрепятствуетУдалениюНепосредственно = Найденный.ПрепятствуетУдалениюНепосредственно;
		
		Если ТипЗнч(ОбъектМетаданныхСсылающегося) = Тип("ОбъектМетаданных") Тогда
			ОбъектМетаданныхСсылающегосяПредставление = ОбъектМетаданныхСсылающегося.Представление();
		КонецЕсли;
		
		ОбъектМетаданныхНеУдаленного = НеУдаленный.Метаданные();
		ОбъектМетаданныхНеУдаленногоЗначение = ОбъектМетаданныхНеУдаленного.ПолноеИмя();
		ОбъектМетаданныхНеУдаленногоПредставление = ОбъектМетаданныхНеУдаленного.Представление();
		
		СтроковоеПредставлениеНеУдаленного = Строка(НеУдаленный);
		СтроковоеПредставлениеСсылающегося = Строка(Ссылающийся) + " - " + ОбъектМетаданныхСсылающегосяПредставление;
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			Если ЗначениеЗаполнено(Ссылающийся) Тогда
				СтроковоеПредставлениеСсылающегося = СтроковоеПредставлениеСсылающегося + " (" + ТекстОшибки + ")";
			Иначе
				СтроковоеПредставлениеНеУдаленного = СтроковоеПредставлениеНеУдаленного + " (" + ТекстОшибки + ")";
			КонецЕсли;
		КонецЕсли;

		// Ветвь метаданного
		СтрокаОбъектаМетаданных = НайтиИлиДобавитьВетвьДереваСКартинкой(
			Дерево.Строки, ОбъектМетаданныхНеУдаленногоЗначение, ОбъектМетаданныхНеУдаленногоПредставление, 0);
		// Ветвь не удаленного объекта
		СтрокаСсылкиНаНеУдаленныйОбъектБД = НайтиИлиДобавитьВетвьДереваСКартинкой(
			СтрокаОбъектаМетаданных.Строки, НеУдаленный, СтроковоеПредставлениеНеУдаленного, 2);
		// Ветвь ссылки на не удаленный объект
		Если ЗначениеЗаполнено(Ссылающийся) Тогда
			НайтиИлиДобавитьВетвьДереваСКартинкой(СтрокаСсылкиНаНеУдаленныйОбъектБД.Строки, 
				Ссылающийся, СтроковоеПредставлениеСсылающегося, ?(ПрепятствуетУдалениюНепосредственно, 1, 2));
		КонецЕсли;
			
	КонецЦикла;
	
	Дерево.Строки.Сортировать("Значение", Истина);
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоОставшихсяОбъектов");
	
	УдаленныхОбъектов = КоличествоУдаляемых - КоличествоНеУдаленныхОбъектов;
	
	Если УдаленныхОбъектов = 0 Тогда
		СтрокаРезультатов = НСтр("ru = 'Не удален ни один из объектов, так как в информационной базе существуют ссылки на удаляемые объекты'");
	Иначе
		СтрокаРезультатов = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Удаление помеченных объектов завершено.
							|Удалено объектов: %1.'"),
							Строка(УдаленныхОбъектов));
	КонецЕсли;
	
	Если КоличествоНеУдаленныхОбъектов > 0 Тогда
		СтрокаРезультатов = СтрокаРезультатов + Символы.ПС +
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалено объектов: %1.
							|Объекты не удалены для сохранения целостности информационной базы, т.к. на них еще имеются ссылки.
							|Нажмите ОК для просмотра списка оставшихся (не удаленных) объектов.'"),
				Строка(КоличествоНеУдаленныхОбъектов));
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокМетаданных()
	
	СписокМетаданныхКонфигурации = ПолучитьСписокМетаданныхКонфигурации();
	СписокМетаданныхКонфигурации.Колонки.Добавить("Пометка", Новый ОписаниеТипов("Булево"));
	ЗначениеВДанныеФормы(СписокМетаданныхКонфигурации, СписокМетаданных);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокМетаданныхКонфигурации()
	
	КоллекцииОбъектовМетаданных = Новый ТаблицаЗначений;
	КоллекцииОбъектовМетаданных.Колонки.Добавить("Имя");
	КоллекцииОбъектовМетаданных.Колонки.Добавить("Синоним");
	КоллекцииОбъектовМетаданных.Колонки.Добавить("Картинка");
	КоллекцииОбъектовМетаданных.Колонки.Добавить("КартинкаОбъекта");
	
	НоваяСтрокаКоллекцииОбъектовМетаданных("Справочники",             "Справочники",               БиблиотекаКартинок.Справочник,             БиблиотекаКартинок.Справочник,                   КоллекцииОбъектовМетаданных);
	НоваяСтрокаКоллекцииОбъектовМетаданных("Документы",               "Документы",                 БиблиотекаКартинок.Документ,               БиблиотекаКартинок.ДокументОбъект,               КоллекцииОбъектовМетаданных);
	НоваяСтрокаКоллекцииОбъектовМетаданных("ПланыВидовХарактеристик", "Планы видов характеристик", БиблиотекаКартинок.ПланВидовХарактеристик, БиблиотекаКартинок.ПланВидовХарактеристикОбъект, КоллекцииОбъектовМетаданных);
	НоваяСтрокаКоллекцииОбъектовМетаданных("БизнесПроцессы",          "Бизнес-процессы",           БиблиотекаКартинок.БизнесПроцесс,          БиблиотекаКартинок.БизнесПроцессОбъект,          КоллекцииОбъектовМетаданных);
	НоваяСтрокаКоллекцииОбъектовМетаданных("Задачи",                  "Задачи",                    БиблиотекаКартинок.Задача,                 БиблиотекаКартинок.ЗадачаОбъект,                 КоллекцииОбъектовМетаданных);
	НоваяСтрокаКоллекцииОбъектовМетаданных("ПланыОбмена",             "Планы обмена",              БиблиотекаКартинок.ПланОбмена,             БиблиотекаКартинок.ПланОбменаОбъект,             КоллекцииОбъектовМетаданных);
	
	// Возвращаемое значение функции
	СписокМетаданных = Новый ДеревоЗначений;
	СписокМетаданных.Колонки.Добавить("Имя");
	СписокМетаданных.Колонки.Добавить("ПолноеИмя");
	СписокМетаданных.Колонки.Добавить("Синоним");
	СписокМетаданных.Колонки.Добавить("Картинка");
	СписокМетаданных.Колонки.Добавить("КартинкаОбъекта");
	
	Для Каждого СтрокаКоллекции Из КоллекцииОбъектовМетаданных Цикл
		
		СтрокаДерева = СписокМетаданных.Строки.Добавить();
		
		ЗаполнитьЗначенияСвойств(СтрокаДерева, СтрокаКоллекции);
		
		Для Каждого ОбъектМетаданных Из Метаданные[СтрокаКоллекции.Имя] Цикл
			
			СтрокаДереваОМ = СтрокаДерева.Строки.Добавить();
			СтрокаДереваОМ.Имя       = ОбъектМетаданных.Имя;
			СтрокаДереваОМ.ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
			СтрокаДереваОМ.Синоним   = ОбъектМетаданных.Синоним;
			СтрокаДереваОМ.Картинка  = СтрокаКоллекции.КартинкаОбъекта;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат СписокМетаданных;
	
КонецФункции

&НаСервереБезКонтекста
Процедура НоваяСтрокаКоллекцииОбъектовМетаданных(Имя, Синоним, Картинка, КартинкаОбъекта, Таблица)
	
	НоваяСтрока 				= Таблица.Добавить();
	НоваяСтрока.Имя             = Имя;
	НоваяСтрока.Синоним         = Синоним;
	НоваяСтрока.Картинка        = Картинка;
	НоваяСтрока.КартинкаОбъекта = КартинкаОбъекта;
	
КонецПроцедуры

// Возвращает помеченные на удаление объекты. Возможен отбор по фильтру.
//
&НаСервереБезКонтекста
Функция ПолучитьПомеченныеНаУдаление(МетаданныеДляПоискаСсылок)
	
	Результат = Новый Массив;
	
	Если МетаданныеДляПоискаСсылок = Неопределено Тогда // Полное удаление, или выбраны все типы
		МассивПомеченные = НайтиПомеченныеНаУдаление();
	Иначе
		
		Если МетаданныеДляПоискаСсылок.Количество() = 0 Тогда
			Возврат Результат;
		Иначе
			Запрос = Новый Запрос;
			Запрос.Текст = ТекстЗапросаПомеченныхНаУдаление(МетаданныеДляПоискаСсылок);
			МассивПомеченные = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		КонецЕсли;
		
	КонецЕсли;
		
	Для Каждого ЭлементПомеченный Из МассивПомеченные Цикл
		Если ПравоДоступа("ИнтерактивноеУдалениеПомеченных", ЭлементПомеченный.Метаданные()) Тогда
			Результат.Добавить(ЭлементПомеченный);
		КонецЕсли
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ТекстЗапросаПомеченныхНаУдаление(СписокМетаданных)
	
	ТекстЗапроса = "";
	
	ШаблонЗапроса = "ВЫБРАТЬ
		|	Таблица.Ссылка
		|ИЗ
		|	%ПолноеИмяМетаданных% КАК Таблица
		|ГДЕ
		|	Таблица.ПометкаУдаления";
	
	Для Каждого ПолноеИмя из СписокМетаданных Цикл
		
		Если ЗначениеЗаполнено(ТекстЗапроса) Тогда
			ТекстЗапроса = ТекстЗапроса + "
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|";
		КонецЕсли;
		
		ТекстЗапроса = ТекстЗапроса + СтрЗаменить(ШаблонЗапроса, "%ПолноеИмяМетаданных%", ПолноеИмя);
		
	КонецЦикла;
	
	Возврат ТекстЗапроса;
	
КонецФункции
