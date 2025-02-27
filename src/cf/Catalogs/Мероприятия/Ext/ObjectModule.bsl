﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

// Обновление адресной книги
Перем ОбновитьДанныеМероприятияВАдреснойКниге;
Перем ОбновитьДанныеУчатсниковМероприятияВАдреснойКниге;
Перем ОбновитьСловаПоискаПоМероприятиюВАдреснойКниге;
Перем ОбновитьДоступностьВПоискеПоМероприятию;

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда 
		
		Организатор = ПользователиКлиентСервер.ТекущийПользователь();
		Куратор = ПользователиКлиентСервер.ТекущийПользователь();
		Подготовил = ПользователиКлиентСервер.ТекущийПользователь();
		Подразделение = РаботаСПользователями.ПолучитьПодразделение(Подготовил);
		Важность = Перечисления.ВариантыВажностиЗадачи.Обычная;
		ТипПрограммы = Перечисления.ТипыПрограммыПротокола.ВТаблице;
		ТипПротокола = Перечисления.ТипыПрограммыПротокола.ВТаблице;
		
		Если Константы.ИспользоватьГрифыДоступа.Получить() Тогда
			ГрифДоступа = Константы.ГрифДоступаПоУмолчанию.Получить();
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Организация) Тогда 
			Организация = РаботаСОрганизациями.ПолучитьОрганизациюПоУмолчанию();
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Проект) Тогда 
			Проект = РаботаСПроектами.ПолучитьПроектПоУмолчанию();
		КонецЕсли;
		
	КонецЕсли;
	
	// Ввод на основании мероприятия
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Мероприятия") Тогда 
		РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, 
			"Наименование, ВидМероприятия, Описание, Важность, МестоПроведения, Папка, Предмет, Проект, Помещение, Подразделение");
			
		ПредыдущееМероприятие = ДанныеЗаполнения;
		Наименование = РеквизитыОснования.Наименование;
		ВидМероприятия = РеквизитыОснования.ВидМероприятия;
		Описание = РеквизитыОснования.Описание;
		Важность = РеквизитыОснования.Важность;
		МестоПроведения = РеквизитыОснования.МестоПроведения;
		Папка = РеквизитыОснования.Папка;  
		Предмет = РеквизитыОснования.Предмет;
		Проект = РеквизитыОснования.Проект;
		Помещение = РеквизитыОснования.Помещение;
		
		Если ЗначениеЗаполнено(РеквизитыОснования.Подразделение) Тогда
			Подразделение = РеквизитыОснования.Подразделение;
		КонецЕсли;
		
		// Переносятся только пункты, по которым не приняты решения
		Для Каждого Строка Из ДанныеЗаполнения.Программа Цикл
			
			НайденныеСтроки = ДанныеЗаполнения.Протокол.НайтиСтроки(
				Новый Структура("НомерПунктаПрограммы", Строка.НомерПункта));
			Если НайденныеСтроки.Количество() > 0 Тогда 
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = Программа.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка, , "ВремяФакт");
			НоваяСтрока.НомерПункта = НоваяСтрока.НомерСтроки;
			
		КонецЦикла;
		УправлениеМероприятиямиКлиентСервер.ПересчитатьНачалоОкончаниеПунктовПрограммы(ЭтотОбъект);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Проекты") Тогда
		
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "ЭтоГруппа") Тогда
			СообщениеПользователю = НСтр("ru = 'Выберите проект, а не группу.'");
			ВызватьИсключение СообщениеПользователю;
		КонецЕсли;
		
		Проект = ДанныеЗаполнения;
		Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Мероприятие по проекту %1'"),
			Строка(Проект));
		
		Если ЗначениеЗаполнено(ДанныеЗаполнения.Подразделение) Тогда
			Подразделение = ДанныеЗаполнения.Подразделение;
		КонецЕсли;
		
	ИначеЕсли ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(ДанныеЗаполнения) Тогда
		
		ДанныеЗаполненияОбъект = ДанныеЗаполнения.ПолучитьОбъект();
		ТекстПисьма = ДанныеЗаполненияОбъект.ПолучитьТекстовоеПредставлениеСодержанияПисьма();
		ТекстПисьмаСТемой = СокрЛП(ДанныеЗаполненияОбъект.Тема) + "." + Символы.ПС + ТекстПисьма;
		
		Предмет = ДанныеЗаполнения;
		Проект = ДанныеЗаполненияОбъект.Проект;
		Описание = ТекстПисьма;
		
		Событие = Обработки.АнализТекста.Событие(ТекстПисьмаСТемой, ДанныеЗаполненияОбъект.Дата);
		Если Событие <> Неопределено Тогда
			ДатаНачала = Событие.Начало;
			ДатаОкончания = Событие.Конец;
			МестоПроведения = Событие.Место;
			Наименование = Событие.Текст;
		Иначе
			Наименование = ДанныеЗаполненияОбъект.Тема;
		КонецЕсли;
		
	ИначеЕсли ДелопроизводствоКлиентСервер.ЭтоДокумент(ДанныеЗаполнения) Тогда 
		
		Предмет = ДанныеЗаполнения;
		
		РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения,
			"Заголовок, Содержание, ГрифДоступа, Организация, Проект, Подразделение");
		Наименование = РеквизитыДокумента.Заголовок;
		Описание = РеквизитыДокумента.Содержание;
		ГрифДоступа = РеквизитыДокумента.ГрифДоступа;
		Организация = РеквизитыДокумента.Организация;
		Проект = РеквизитыДокумента.Проект;
		
		Если ЗначениеЗаполнено(РеквизитыДокумента.Подразделение) Тогда
			Подразделение = РеквизитыДокумента.Подразделение;
		КонецЕсли;
		
		Если ДелопроизводствоКлиентСервер.ЭтоВходящийДокумент(ДанныеЗаполнения) Тогда
			РеквизитыВходящегоДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Отправитель, Подписал");
			Организатор = РеквизитыВходящегоДокумента.Отправитель;
			ОрганизаторКонтактноеЛицо = РеквизитыВходящегоДокумента.Подписал;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Массив") 
		И ДанныеЗаполнения.Количество() > 0
		И ТипЗнч(ДанныеЗаполнения[0]) = Тип("СправочникСсылка.Файлы") Тогда 
		
		Если ДанныеЗаполнения.Количество() = 1 И Не ЗначениеЗаполнено(Наименование) Тогда 
			Наименование = ДанныеЗаполнения[0].ПолноеНаименование;
		КонецЕсли;
		
		Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") И Не ЗначениеЗаполнено(Проект) Тогда
			Проекты = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ДанныеЗаполнения, "Проект");
			Проект = Проекты.Получить(ДанныеЗаполнения[0]);
			Для Каждого Строка Из Проекты Цикл
				Если Строка.Значение <> Проект Тогда 
					Проект = Неопределено;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.КонтактныеЛица") Тогда
		
		Предмет = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "Владелец");
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Мероприятие") Тогда
			
			ЗаполнитьНаОснованииМероприятия(ДанныеЗаполнения.Мероприятие);
			
		КонецЕсли;
		
	Иначе
		
		Если ДанныеЗаполнения <> Неопределено И ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Тогда
			Предмет = ДанныеЗаполнения;
		КонецЕсли;
		
	КонецЕсли;
	
	УправлениеМероприятиямиПереопределяемый.ОбработкаЗаполнения(
		ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ПредыдущееМероприятие) И ПредыдущееМероприятие = Ссылка Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Указана ссылка на самого себя!'"),
			ЭтотОбъект,
			"ПредыдущееМероприятие",, 
			Отказ);
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ДатаНачала) Или ЗначениеЗаполнено(Помещение) Тогда 
		ПроверяемыеРеквизиты.Добавить("ДатаОкончания");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаОкончания) Или ЗначениеЗаполнено(Помещение) Тогда 
		ПроверяемыеРеквизиты.Добавить("ДатаНачала");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаНачала) И ЗначениеЗаполнено(ДатаОкончания) Тогда 
		Если ДатаНачала = ДатаОкончания Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Указанная дата окончания совпадает с датой начала!'"),
				ЭтотОбъект,
				"ДатаОкончания",, 
				Отказ);
		ИначеЕсли ДатаОкончания < ДатаНачала Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Указанная дата окончания меньше, чем дата начала!'"),
				ЭтотОбъект,
				"ДатаОкончания",, 
				Отказ);
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	РеквизитыМероприятияПоСсылке = 
		ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ПометкаУдаления, Папка, Наименование, Протокол");
	
	// Пометка на удаление приложенных файлов
	ПредыдущаяПометкаУдаления = Ложь;
	Если Не Ссылка.Пустая() Тогда
		ПредыдущаяПометкаУдаления = РеквизитыМероприятияПоСсылке.ПометкаУдаления;
	КонецЕсли;
	ДополнительныеСвойства.Вставить("ПредыдущаяПометкаУдаления", ПредыдущаяПометкаУдаления);
	
	Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда 
		
		Если ПометкаУдаления Тогда
			ДополнительныеСвойства.Вставить("НужноПометитьНаУдалениеБизнесСобытия", Истина);
		КонецЕсли;
		
		Если ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Ссылка).Удаление Тогда 
			РаботаСФайламиВызовСервера.ПометитьНаУдалениеПриложенныеФайлы(Ссылка, ПометкаУдаления);
		Иначе
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'У вас нет права ""Пометка на удаление"" мероприятия ""%1"".'"),
				Строка(Ссылка));
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
	КонецЕсли;	
	
	// Заполнение периода строкой
	ПериодСтрокой = УправлениеМероприятиями.ПериодСтрокой(ДатаНачала, ДатаОкончания, "");
	
	// Обработка рабочей группы
	СсылкаОбъекта = Ссылка;
	// Установка ссылки нового
	Если Не ЗначениеЗаполнено(СсылкаОбъекта) Тогда
		СсылкаОбъекта = ПолучитьСсылкуНового();
		Если Не ЗначениеЗаполнено(СсылкаОбъекта) Тогда
			СсылкаНового = Справочники.Мероприятия.ПолучитьСсылку();
			УстановитьСсылкуНового(СсылкаНового);
			СсылкаОбъекта = СсылкаНового;
		КонецЕсли;
	КонецЕсли;
	
	// Определение дескрипторов для проверки прав при записи рабочей группы.
	Если ДокументооборотПраваДоступаПовтИсп.ВключеноИспользованиеПравДоступа() Тогда
		ДокументооборотПраваДоступа.ОпределитьДескрипторыОбъекта(ЭтотОбъект);
	КонецЕсли;
	
	// Подготовка рабочей группы
	РабочаяГруппа = РегистрыСведений.РабочиеГруппы.ПолучитьУчастниковПоОбъекту(СсылкаОбъекта);
	
	// Добавление автоматических участников из самого объекта
	Если РаботаСРабочимиГруппами.ПоОбъектуВедетсяАвтоматическоеЗаполнениеРабочейГруппы(ЭтотОбъект) Тогда
		
		ДобавитьУчастниковРабочейГруппыВНабор(РабочаяГруппа);
		
	КонецЕсли;
	
	// Добавление участников, переданных "снаружи", например из формы объекта
	Если ДополнительныеСвойства.Свойство("РабочаяГруппаДобавить") Тогда
		
		Для Каждого Эл Из ДополнительныеСвойства.РабочаяГруппаДобавить Цикл
			
			// Добавление участника в итоговую рабочую группу
			Строка = РабочаяГруппа.Добавить();
			Строка.Участник = Эл.Участник;
			Строка.Изменение = Эл.Изменение;
			
		КонецЦикла;	
			
	КонецЕсли;		
	
	// Удаление участников, переданных "снаружи", например из формы объекта
	Если ДополнительныеСвойства.Свойство("РабочаяГруппаУдалить") Тогда
		
		Для Каждого Эл Из ДополнительныеСвойства.РабочаяГруппаУдалить Цикл
			
			// Поиск удаляемого участника в итоговой рабочей группе
			Для Каждого Эл2 Из РабочаяГруппа Цикл
				
				Если Эл2.Участник = Эл.Участник 
					И Эл2.Изменение = Эл.Изменение Тогда
					
					// Удаление участника из итоговой рабочей группы
					РабочаяГруппа.Удалить(Эл2);
					Прервать;
					
				КонецЕсли;
				
			КонецЦикла;	
				
		КонецЦикла;	
			
	КонецЕсли;		
	
	// Обработка обязательного заполнения рабочих групп 
	Если РабочаяГруппа.Количество() = 0 Тогда
	
		Если РаботаСРабочимиГруппами.ОбязательноеЗаполнениеРабочихГруппДокументов(ВидМероприятия) Тогда
			Строка = РабочаяГруппа.Добавить();
			Строка.Участник = ПользователиКлиентСервер.ТекущийПользователь();
		КонецЕсли;
		
	КонецЕсли;		
	
	// Запись итоговой рабочей группы
	РаботаСРабочимиГруппами.ПерезаписатьРабочуюГруппуОбъекта(
		СсылкаОбъекта,
		РабочаяГруппа,
		Ложь, //ОбновитьПраваДоступа
		Пользователи.ТекущийПользователь());
	
	// Установка необходимости обновления прав доступа
	ДополнительныеСвойства.Вставить("ДополнительныеПравообразующиеЗначенияИзменены");
	
	// Обновление адресной книги
	ОбновитьДанныеМероприятияВАдреснойКниге = Ложь;
	ОбновитьДанныеУчатсниковМероприятияВАдреснойКниге = Ложь;
	ОбновитьСловаПоискаПоМероприятиюВАдреснойКниге = Ложь;
	ОбновитьДоступностьВПоискеПоМероприятию = Ложь;
	Если РаботаСАдреснойКнигой.ТребуетсяОбновлениеАдреснойКниги(ЭтотОбъект) Тогда
		Если ЭтоНовый() Тогда
			ОбновитьДанныеМероприятияВАдреснойКниге = Истина;
			ОбновитьСловаПоискаПоМероприятию = Истина;
			ОбновитьСловаПоискаПоМероприятиюВАдреснойКниге = Истина;
		Иначе
			Если РеквизитыМероприятияПоСсылке.Папка <> Папка Тогда
				ОбновитьДанныеМероприятияВАдреснойКниге = Истина;
			КонецЕсли;
			
			Если РеквизитыМероприятияПоСсылке.ПометкаУдаления <> ПометкаУдаления Тогда
				ОбновитьДанныеМероприятияВАдреснойКниге = Истина;
				ОбновитьДоступностьВПоискеПоМероприятию = Истина;
				ОбновитьДанныеУчатсниковМероприятияВАдреснойКниге = Истина;
			КонецЕсли;
			
			Если РеквизитыМероприятияПоСсылке.Наименование <> Наименование Тогда
				ОбновитьСловаПоискаПоМероприятиюВАдреснойКниге = Истина;
				ОбновитьДанныеМероприятияВАдреснойКниге = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Пометка удаления удаленных из протокола пунктов.
	Если ЭтоНовый() Тогда
		ИсходныйПротокол = Новый Массив;
	Иначе
		ИсходныйПротокол = РеквизитыМероприятияПоСсылке.Протокол.Выгрузить().ВыгрузитьКолонку("ПунктПротокола");
	КонецЕсли;
	ДополнительныеСвойства.Вставить("ИсходныйПротокол", ИсходныйПротокол);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка
		И ЗначениеЗаполнено(ОбменДанными.Отправитель)
		И ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(ОбменДанными.Отправитель) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	Если МиграцияПриложенийПереопределяемый.ЭтоЗагрузка(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	// Возможно, выполнена явная регистрация событий при загрузке объекта.
	Если Не ДополнительныеСвойства.Свойство("НеРегистрироватьБизнесСобытия") Тогда
		Если ДополнительныеСвойства.Свойство("ЭтоНовый") И ДополнительныеСвойства.ЭтоНовый Тогда
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.СозданиеМероприятия);	
		Иначе
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.ИзменениеМероприятия);
		КонецЕсли;	
	КонецЕсли;	
	
	Если ДополнительныеСвойства.Свойство("НужноПометитьНаУдалениеБизнесСобытия") Тогда
		БизнесСобытияВызовСервера.ПометитьНаУдалениеСобытияПоИсточнику(Ссылка);
	КонецЕсли;	
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПредыдущаяПометкаУдаления = Ложь;
	Если ДополнительныеСвойства.Свойство("ПредыдущаяПометкаУдаления") Тогда
		ПредыдущаяПометкаУдаления = ДополнительныеСвойства.ПредыдущаяПометкаУдаления;
	КонецЕсли;
	
	Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда
		ПротоколированиеРаботыПользователей.ЗаписатьПометкуУдаления(Ссылка, ПометкаУдаления);
	КонецЕсли;	
	
	РегистрыСведений.ДанныеМероприятий.ОбновитьДанныеМероприятия(Ссылка);
	
	// Обновление адресной книги
	Если ОбновитьДанныеМероприятияВАдреснойКниге Тогда
		Справочники.АдреснаяКнига.ОбновитьДанныеОбъекта(
			Ссылка, Папка, Справочники.АдреснаяКнига.ПоМероприятиям, Ссылка);
	КонецЕсли;
	Если ОбновитьДанныеУчатсниковМероприятияВАдреснойКниге Тогда
		УчастникиМероприятия = 
			УправлениеМероприятиями.ПолучитьУчастниковМероприятия(Ссылка, Истина);
		УчастникиМероприятия = УчастникиМероприятия.ВыгрузитьКолонку("Исполнитель");
				
		Справочники.АдреснаяКнига.ОбновитьСписокПодчиненныхОбъектов(
			Ссылка,
			Папка,
			УчастникиМероприятия,
			Справочники.АдреснаяКнига.ПоМероприятиям,
			Ссылка);
	КонецЕсли;
	Если ОбновитьСловаПоискаПоМероприятиюВАдреснойКниге Тогда
		РегистрыСведений.ПоискВАдреснойКниге.ОбновитьСловаПоискаПоМероприятию(ЭтотОбъект);
	КонецЕсли;
	Если ОбновитьДоступностьВПоискеПоМероприятию Тогда
		РегистрыСведений.ПоискВАдреснойКниге.ОбновитьДоступностьВПоиске(ЭтотОбъект);
	КонецЕсли;
		
	// Пометка удаления удаленных из протокола пунктов.
	Для Каждого ПунктПротокола Из ДополнительныеСвойства.ИсходныйПротокол Цикл
		
		Если Протокол.Найти(ПунктПротокола, "ПунктПротокола") <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ПунктПротоколаОбъект = ПунктПротокола.ПолучитьОбъект();
		ПунктПротоколаОбъект.Заблокировать();
		ПунктПротоколаОбъект.УстановитьПометкуУдаления(Истина);
		ИсторияРаботыПользователя.Добавить(ПунктПротоколаОбъект.Ссылка);
		
	КонецЦикла;
	
	Если ДополнительныеСвойства.Свойство("ИзмененныеСостояния") Тогда
		Для Каждого ИзменноеСостояние Из ДополнительныеСвойства.ИзмененныеСостояния Цикл
			ЗаписатьСостояниеМероприятия(
				ИзменноеСостояние.НачальноеСостояние,
				ИзменноеСостояние.Состояние,
				ИзменноеСостояние.Период);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Организатор = ПользователиКлиентСервер.ТекущийПользователь();
	Подготовил = ПользователиКлиентСервер.ТекущийПользователь();
	
	Протокол.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Добавляет в набор участников рабочей группы.
//
// Параметры:
//  ТаблицаНабора	 - РегистрСведенийНаборЗаписей.РабочиеГруппы - Набор участников рабочей группы.
//
Процедура ДобавитьУчастниковРабочейГруппыВНабор(ТаблицаНабора)
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		
		ИсходныеРеквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка,
			"ВидМероприятия, Председатель, Секретарь, Организатор, Куратор, Подготовил");
			
		Если ИсходныеРеквизиты.ВидМероприятия = ВидМероприятия Тогда
			ДобавитьТолькоНовыхУчастниковРабочейГруппыВНабор(ТаблицаНабора, ИсходныеРеквизиты);
		Иначе
			ДобавитьВсехУчастниковРабочейГруппыВНабор(ТаблицаНабора);
		КонецЕсли;	
		
	Иначе	
		
		ДобавитьВсехУчастниковРабочейГруппыВНабор(ТаблицаНабора);
		
	КонецЕсли;
	
КонецПроцедуры

// Добавляет в набор новых участников рабочей группы.
//
// Параметры:
//  ТаблицаНабора		 - РегистрСведенийНаборЗаписей.РабочиеГруппы - Набор участников рабочей группы.
//  ИсходныеРеквизиты	 - Структура								 - Исходные реквизиты.
//
Процедура ДобавитьТолькоНовыхУчастниковРабочейГруппыВНабор(ТаблицаНабора, ИсходныеРеквизиты)
	
	// Добавление реквизита Председатель
	Если ИсходныеРеквизиты.Председатель <> Председатель Тогда
		ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Председатель, Истина);
	КонецЕсли;
	
	// Добавление реквизита Секретарь
	Если ИсходныеРеквизиты.Секретарь <> Секретарь Тогда 
		ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Секретарь, Истина);
	КонецЕсли;
	
	// Добавление реквизита Организатор
	Если ИсходныеРеквизиты.Организатор <> Организатор Тогда
		ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Организатор, Истина);
	КонецЕсли;
	
	// Добавление реквизита Куратор
	Если ИсходныеРеквизиты.Куратор <> Куратор Тогда
		ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Куратор, Истина);
	КонецЕсли;
	
	// Добавление реквизита Подготовил
	Если ИсходныеРеквизиты.Подготовил <> Подготовил Тогда
		ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Подготовил, Истина);
	КонецЕсли;
	
	// Обработка табличной части Участники
	Если ДополнительныеСвойства.Свойство("СписокУчастников") Тогда
		ИсходныеУчастники = УправлениеМероприятиями.ПолучитьУчастниковМероприятия(Ссылка, Истина);
		ТекущиеУчастники = ДополнительныеСвойства.СписокУчастников;
		Для Каждого Эл Из ТекущиеУчастники Цикл
			
			// Поиск в исходной табличной части 
			Найден = Ложь;
			Для Каждого Эл2 Из ИсходныеУчастники Цикл
				Если Эл.Исполнитель = Эл2.Исполнитель Тогда
					Найден = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			// Добавление нового участника рабочей группы
			Если Не Найден  Тогда
				ДобавитьУчастникаВТаблицуНабора(
					ТаблицаНабора, 
					Эл.Исполнитель);
			КонецЕсли;	
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьВсехУчастниковРабочейГруппыВНабор(ТаблицаНабора)
	
	ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Председатель, Истина);
	ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Секретарь, Истина);
	ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Организатор, Истина);
	ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Куратор, Истина);
	ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Подготовил, Истина);
	
	// Обработка табличной части Участники
	Если ДополнительныеСвойства.Свойство("СписокУчастников") Тогда
		ТекущиеУчастники = ДополнительныеСвойства.СписокУчастников;
		Для Каждого Эл Из ТекущиеУчастники Цикл
			ДобавитьУчастникаВТаблицуНабора(
				ТаблицаНабора, 
				Эл.Исполнитель);
		КонецЦикла;
	КонецЕсли;
	
	// Добавление контролеров
	Если Не Ссылка.Пустая() Тогда 
		Контроль.ДобавитьКонтролеровВТаблицу(ТаблицаНабора, Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьУчастникаВТаблицуНабора(
			ТаблицаНабора,
			Участник,
			Изменение = Ложь) Экспорт
	
	Если ТипЗнч(Участник) = Тип("СправочникСсылка.Пользователи")
		Или ТипЗнч(Участник) = Тип("СправочникСсылка.ПолныеРоли") Тогда
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(
			ТаблицаНабора, Участник, Изменение);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьСостояниеМероприятия(НачальноеСостояние, Состояние, Период)
	
	Если НачальноеСостояние = Состояние Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Состояние) Тогда 
		УправлениеМероприятиями.ЗаписатьСостояниеМероприятия(
			Ссылка,
			Период,
			Состояние,
			ПользователиКлиентСервер.ТекущийПользователь());
	Иначе
		УправлениеМероприятиями.ОчиститьСостояниеМероприятия(
			Ссылка,
			НачальноеСостояние);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет мероприятие на основании мероприятия.
//
// Параметры:
//  Мероприятие - СправочникСсылка.Мероприятия - Мероприятие.
//
Процедура ЗаполнитьНаОснованииМероприятия(Мероприятие)
	
	Если Не ЗначениеЗаполнено(Мероприятие) Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Мероприятие, 
		"Наименование, ВидМероприятия, Описание, Важность, МестоПроведения,
		|Папка, Предмет, Проект, Помещение, Подразделение, ДополнительныеРеквизиты");
	
	ПредыдущееМероприятие = Мероприятие;
	Наименование = РеквизитыОснования.Наименование;
	ВидМероприятия = РеквизитыОснования.ВидМероприятия;
	Описание = РеквизитыОснования.Описание;
	Важность = РеквизитыОснования.Важность;
	МестоПроведения = РеквизитыОснования.МестоПроведения;
	Папка = РеквизитыОснования.Папка;  
	Предмет = РеквизитыОснования.Предмет;
	Проект = РеквизитыОснования.Проект;
	Помещение = РеквизитыОснования.Помещение;
	
	Если ЗначениеЗаполнено(РеквизитыОснования.Подразделение) Тогда
		Подразделение = РеквизитыОснования.Подразделение;
	КонецЕсли;
	
	Для Каждого Строка Из РеквизитыОснования.ДополнительныеРеквизиты.Выгрузить() Цикл
		НоваяСтрока = ДополнительныеРеквизиты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	
	// Переносятся только пункты, по которым не приняты решения
	Для Каждого Строка Из Мероприятие.Программа Цикл
		
		НайденныеСтроки = Мероприятие.Протокол.НайтиСтроки(
			Новый Структура("НомерПунктаПрограммы", Строка.НомерПункта));
		Если НайденныеСтроки.Количество() > 0 Тогда 
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Программа.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка, , "ВремяФакт");
		НоваяСтрока.НомерПункта = НоваяСтрока.НомерСтроки;
		
	КонецЦикла;
	УправлениеМероприятиямиКлиентСервер.ПересчитатьНачалоОкончаниеПунктовПрограммы(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли 