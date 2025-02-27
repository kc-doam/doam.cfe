﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Назад.Доступность = Ложь;
	Элементы.Закрыть.Видимость = Ложь;
	ЭтоБазоваяВерсияКонфигурации = Ложь;
	
	Итого = "<HTML><HEAD>
			| <META content=""text/html; charset=utf-8"" http-equiv=Content-Type>
			| </HEAD>
			|<style type=""text/css"">
			|	body {
			|		overflow:    auto;
			|		margin-top:  6px; 		 
			|		margin-left: 10px; 
			|		margin-bottom: 6px;
			|		font-family: Arial, sans-serif;
			|		font-size:   12pt;}
			|	p {
			|		margin-top: 7px;}
			|	UL {
			|		padding: 10;
			|		margin: 10;
			|	}
			|</style>
			| <BODY>
			| <H3>Программа готова к работе</H3>
			|</UL></BODY></HTML>";
			
	Обработки.ЗагрузкаКлассификатораОбращенийГраждан.ЗаполнитьТаблицыФормыДаннымиКлассификатора(ЭтаФорма);
	Константы.АктуализироватьКлассификаторОбращенийГраждан.Установить(Ложь);
	
	ЭтоБазоваяВерсия = СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы[0] Тогда
		Элементы.Назад.Доступность = Истина;
	КонецЕсли;
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРазделы Тогда
		
		ЗагрузитьДанныеКлассификатора("Разделы");
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаТематикиИТемы;
	
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаТематикиИТемы Тогда
		
		ЗагрузитьДанныеКлассификатора("ТематикиИТемы");
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВопросы;
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВопросы Тогда
		
		ЗагрузитьДанныеКлассификатора("Вопросы");
		Элементы.Страницы.ТекущаяСтраница = Элементы.Готово;
		
		Состояние(НСтр("ru = 'Устанавливаются соответствия разделов, тем, тематик и вопросов.'"));
		УстановитьСоответствияВопросов();
	КонецЕсли;
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы[Элементы.Страницы.ПодчиненныеЭлементы.Количество() - 1] Тогда
		Элементы.Далее.Видимость = Ложь;
		Элементы.Закрыть.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы[Элементы.Страницы.ПодчиненныеЭлементы.Количество() - 1] Тогда
		Элементы.Далее.Видимость = Истина;
		Элементы.Закрыть.Видимость = Ложь;
	КонецЕсли;	
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Готово Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВопросы;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВопросы Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаТематикиИТемы;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаТематикиИТемы Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРазделы;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРазделы Тогда
		Если ЭтоБазоваяВерсия Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.РассылкаСообщений;
		Иначе
			Элементы.Страницы.ТекущаяСтраница = Элементы.Пользователи;
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы[0] Тогда
		Элементы.Назад.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтметки(Команда)
	
	УстановитьЗначениеОтметки(СтрЗаменить(Элементы.Страницы.ТекущаяСтраница.Имя, "Страница", ""), Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеОтметки(Команда)
	
	УстановитьЗначениеОтметки(СтрЗаменить(Элементы.Страницы.ТекущаяСтраница.Имя, "Страница", ""), Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандТаблицФормы

&НаКлиенте
Процедура ТематикиИТемыВыбранПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ТематикиИТемы.ТекущаяСтрока;
	ТекущаяСтрока = ?(Не ТекущаяСтрока = Неопределено,
		ТематикиИТемы.НайтиПоИдентификатору(ТекущаяСтрока),
		Неопределено);
		
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока.Выбран = ?(ТекущаяСтрока.Выбран > 1, 0, ТекущаяСтрока.Выбран);
	Если ТекущаяСтрока.ПолучитьЭлементы().Количество() Тогда
		УстановитьЗначениеОтметкиДерева(ТекущаяСтрока, ТекущаяСтрока.Выбран);
		ТекущаяСтрока.ЭлементовВыбрано = ?(ТекущаяСтрока.Выбран, ТекущаяСтрока.ЭлементовНаУровне, 0);
	Иначе
		Родитель = ТекущаяСтрока.ПолучитьРодителя();
		Если Не Родитель = Неопределено Тогда
			Родитель.ЭлементовВыбрано = 
				Родитель.ЭлементовВыбрано + ?(ТекущаяСтрока.Выбран = 0, -1, ТекущаяСтрока.Выбран);
			Родитель.Выбран = 
				?(Родитель.ЭлементовНаУровне = Родитель.ЭлементовВыбрано,
					1,				
					?(Родитель.ЭлементовВыбрано > 0, 2, 0));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьДанныеКлассификатора(ИмяТаблицыФормы)
	
	Если Не ЗагрузитьДанныеКлассификатораНаСервере(ИмяТаблицыФормы) Тогда
		ТекстПредупреждения = НСтр("ru = 'Не удалось выполнить загрузку данных классификатора обращений граждан.
			|Выполните загрузку данных классификатора позже в окне ""Настройка программы"".'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьДанныеКлассификатораНаСервере(ИмяТаблицыФормы)
	
	Результат = Истина;
	
	Менеджер = Обработки.ЗагрузкаКлассификатораОбращенийГраждан;
	Если ТипЗнч(ЭтотОбъект[ИмяТаблицыФормы]) = Тип("ДанныеФормыДерево") Тогда
		ДанныеДляЗагрузки = Обработки.ЗагрузкаКлассификатораОбращенийГраждан.ПодготовитьДанныеДереваТематикИТемКЗагрузке(ЭтаФорма);
		
		Результат = Менеджер.ЗаписатьДанныеКлассификатораВИнформационнуюБазу(
			ДанныеДляЗагрузки.Тематики,
			"Справочник.ТематикиОбращений");
			
		Если Результат Тогда
			Результат = Менеджер.ЗаписатьДанныеКлассификатораВИнформационнуюБазу(
				ДанныеДляЗагрузки.Темы,
				"Справочник.ТемыОбращений");
		КонецЕсли;
	Иначе
		Результат = Менеджер.ЗаписатьДанныеКлассификатораВИнформационнуюБазу(
			ЭтотОбъект[ИмяТаблицыФормы].Выгрузить(Новый Структура("Выбран", Истина)),
			"Справочник." + ИмяТаблицыФормы + "Обращений");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура УстановитьЗначениеОтметки(Список, Режим = Неопределено)
	
	Если Элементы[Список].Отображение = ОтображениеТаблицы.Список Тогда
		Для Каждого СтрокаСписка Из ЭтотОбъект[Список] Цикл
			СтрокаСписка.Выбран = ?(Режим = Неопределено, Не СтрокаСписка.Выбран, Режим);
		КонецЦикла;
	Иначе
		УстановитьЗначениеОтметкиДерева(ЭтотОбъект[Список], Режим);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗначениеОтметкиДерева(Список, Режим)
	
	ТекущийУровень = Список.ПолучитьЭлементы();
	Для Каждого СтрокаСписка Из ТекущийУровень Цикл
		СтрокаСписка.Выбран = ?(Режим = Неопределено, Не СтрокаСписка.Выбран, Режим);
		Если СтрокаСписка.ПолучитьЭлементы().Количество() Тогда
			УстановитьЗначениеОтметкиДерева(СтрокаСписка, СтрокаСписка.Выбран);
			СтрокаСписка.ЭлементовВыбрано = ?(СтрокаСписка.Выбран, СтрокаСписка.ЭлементовНаУровне, 0);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСоответствияВопросов()
	
	Обработки.ЗагрузкаКлассификатораОбращенийГраждан.УстановитьСоответствияВопросов();
	
КонецПроцедуры

#КонецОбласти