﻿
// Обновляет данные миникарточки документа в списках
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма списка Входящих, Исходящих или Внутренних документов, 
//   в котором показывается Миникарточка
//
Процедура ОбновитьМиникарточку(Форма) Экспорт 
	
	Список = Форма.Элементы.Список;
	
	ТекущиеДанные = РаботаСоСпискамиДокументовКлиент.ПолучитьДанныеТекущейСтрокиСписка(Список, Список.ТекущаяСтрока);
	Если ТекущиеДанные = Неопределено Тогда
		Форма.ТекущийДокумент = Неопределено;
		
	ИначеЕсли Форма.ИмяФормы = "РегистрСведений.МоиДокументы.Форма.ФормаМоиДокументы" Тогда 
		Форма.ТекущийДокумент = ТекущиеДанные.Документ;
		
	Иначе
		Форма.ТекущийДокумент = ТекущиеДанные.Ссылка;
		
	КонецЕсли;
	
	ТекущийДокумент = Форма.ТекущийДокумент;
	ДанныеМиникарточки = ОбзорСпискаДокументов.ПолучитьДанныеМиникарточки(
		ТекущийДокумент, Форма.ПоказыватьУдаленныеФайлы);
	
	Форма.ОбзорHTML = ДанныеМиникарточки.Обзор;
	
	Форма.ЗапретитьРедактироватьФайлы = ДанныеМиникарточки.ЗапретитьРедактироватьФайлы;
	Форма.ЗапретитьУдалятьФайлы = ДанныеМиникарточки.ЗапретитьУдалятьФайлы;
	Форма.СостояниеТекст = ДанныеМиникарточки.СостояниеТекст;
	
	Форма.Файлы.Очистить();
	Для Каждого Строка Из ДанныеМиникарточки.Файлы Цикл
		НоваяСтрока = Форма.Файлы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	Форма.КоличествоФайлов = ДанныеМиникарточки.Файлы.Количество();
	
	Форма.ДеревоСвязей.ПолучитьЭлементы().Очистить();
	Для Каждого Строка Из ДанныеМиникарточки.Связи Цикл
		НоваяСтрока = Форма.ДеревоСвязей.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		
		Для Каждого Строка1 Из Строка.Подстроки Цикл
			НоваяСтрока1 = НоваяСтрока.ПолучитьЭлементы().Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока1, Строка1);
		КонецЦикла;
	КонецЦикла;
	Форма.КоличествоСвязей = ДанныеМиникарточки.Связи.Количество();
	
	Форма.СписокЗадачи.Очистить();
	Для Каждого Строка Из ДанныеМиникарточки.Задачи Цикл
		НоваяСтрока = Форма.СписокЗадачи.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	Форма.КоличествоЗадач = ДанныеМиникарточки.Задачи.Количество();
	
	УстановитьДоступностьКомандМиникарточкиПоСостоянию(Форма, ДанныеМиникарточки);
	Форма.ДоступныеПоля = ДанныеМиникарточки.ОбщиеДоступныеПоля;
	Форма.НедоступныеПоля = ДанныеМиникарточки.ОбщиеНедоступныеПоля;
	
	ВывестиЗаголовкиЗакладок(Форма);
	
КонецПроцедуры

// Обновляет заголовки закладок миникарточки документа в списках
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма списка Входящих, Исходящих или Внутренних документов, 
//   в котором обновляются заголовки
//
Процедура ВывестиЗаголовкиЗакладок(Форма) Экспорт 
	
	Если Форма.КоличествоФайлов > 0 Тогда 
		Форма.ЗаголовокСодержаниеФайлы = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Содержание, Файлы (%1)'"),
			Форма.КоличествоФайлов);
	Иначе
		Форма.ЗаголовокСодержаниеФайлы = 
			НСтр("ru = 'Содержание, Файлы'");
	КонецЕсли;
		
	Если Форма.КоличествоЗадач > 0 И Форма.КоличествоСвязей > 0 Тогда 
		
		Форма.ЗаголовокЗадачиСвязи = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Задачи (%1), Связи (%2)'"),
			Форма.КоличествоЗадач,
			Форма.КоличествоСвязей);
		
	ИначеЕсли Форма.КоличествоЗадач > 0 Тогда 
		
		Форма.ЗаголовокЗадачиСвязи = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Задачи (%1), Связи'"),
			Форма.КоличествоЗадач);
		
	ИначеЕсли Форма.КоличествоСвязей > 0 Тогда 
		
		Форма.ЗаголовокЗадачиСвязи = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Задачи, Связи (%1)'"),
			Форма.КоличествоСвязей);
			
	Иначе
		
		Форма.ЗаголовокЗадачиСвязи = 
			НСтр("ru = 'Задачи, Связи'");
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список файлов миникарточки документа в списках
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма списка Входящих, Исходящих или Внутренних документов, 
//   в котором обновляется список файлов
//
Процедура ЗаполнитьСписокФайлов(Форма) Экспорт 
	
	ДанныеМиникарточки = ОбзорСпискаДокументов.ПолучитьДанныеМиникарточки(
		Форма.ТекущийДокумент, Форма.ПоказыватьУдаленныеФайлы);
	
	Форма.Файлы.Очистить();
	Для Каждого Строка Из ДанныеМиникарточки.Файлы Цикл
		НоваяСтрока = Форма.Файлы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;	
	Форма.КоличествоФайлов = ДанныеМиникарточки.Файлы.Количество();
	
	ВывестиЗаголовкиЗакладок(Форма);
	
КонецПроцедуры

// Заполняет список задач миникарточки документа в списках
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма списка Входящих, Исходящих или Внутренних документов, 
//   в котором обновляется список задач
//
Процедура ЗаполнитьСписокЗадач(Форма) Экспорт
	
	ДанныеМиникарточки = ОбзорСпискаДокументов.ПолучитьДанныеМиникарточки(Форма.ТекущийДокумент);
	
	Форма.СписокЗадачи.Очистить();
	Для Каждого Строка Из ДанныеМиникарточки.Задачи Цикл
		НоваяСтрока = Форма.СписокЗадачи.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;	
	Форма.КоличествоЗадач = ДанныеМиникарточки.Задачи.Количество();
	
	ВывестиЗаголовкиЗакладок(Форма);
	
КонецПроцедуры

// Заполняет список связей миникарточки документа в списках
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма списка Входящих, Исходящих или Внутренних документов, 
//   в котором обновляется дерево связей
//
Процедура ЗаполнитьСвязи(Форма) Экспорт
	
	ДанныеМиникарточки = ОбзорСпискаДокументов.ПолучитьДанныеМиникарточки(Форма.ТекущийДокумент);
	
	Форма.ДеревоСвязей.ПолучитьЭлементы().Очистить();
	Для Каждого Строка Из ДанныеМиникарточки.Связи Цикл
		НоваяСтрока = Форма.ДеревоСвязей.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		
		Для Каждого Строка1 Из Строка.Подстроки Цикл
			НоваяСтрока1 = НоваяСтрока.ПолучитьЭлементы().Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока1, Строка1);
		КонецЦикла;	
	КонецЦикла;	
	Форма.КоличествоСвязей = ДанныеМиникарточки.Связи.Количество();
	
	ВывестиЗаголовкиЗакладок(Форма);
	
КонецПроцедуры

// Устанавливает доступность команд списка Файлы в миникарточке документа
//
// Параметры:
//   ТекущиеДанные - ТаблицаЗначений - таблица ФайлыДокумента формы списка
//   Элементы - ВсеЭлементыФормы - элементы формы 
//
Процедура УстановитьДоступностьКоманд(ТекущиеДанные, Форма) Экспорт
	
	Элементы = Форма.Элементы;
	
	Если ТекущиеДанные = Неопределено Тогда
		
		УстановитьДоступностьКоманды(Элементы["КонтекстноеМенюФайлыОткрытьФайл"], Ложь);
		УстановитьДоступностьКоманды(Элементы["КонтекстноеМенюФайлыНапечатать"], Ложь);
		УстановитьДоступностьКоманды(Элементы["КонтекстноеМенюФайлыРедактировать"], Ложь);
		УстановитьДоступностьКоманды(Элементы["КонтекстноеМенюФайлыЗакончитьРедактирование"], Ложь);
		УстановитьДоступностьКоманды(Элементы["КонтекстноеМенюФайлыИзменить"], Ложь);
		УстановитьДоступностьКоманды(Элементы["КонтекстноеМенюФайлыСохранитьИзменения"], Ложь);
		УстановитьДоступностьКоманды(Элементы["КонтекстноеМенюФайлыУдалить"], Ложь);
		УстановитьДоступностьКоманды(Элементы["КонтекстноеМенюФайлыСохранитьКак"], Ложь);
		УстановитьДоступностьКоманды(Элементы["КонтекстноеМенюФайлыОбновитьИзФайлаНаДиске"], Ложь);
		
	Иначе
		
		РедактируетТекущийПользователь = ТекущиеДанные.РедактируетТекущийПользователь;
		Редактирует = ТекущиеДанные.Редактирует;
		ПодписанЭП = ТекущиеДанные.ПодписанЭП;
		Зашифрован = ТекущиеДанные.Зашифрован;
		СозданПоШаблонуДокумента = ТекущиеДанные.СозданПоШаблонуДокумента;
		РазрешеноРедактирование = Не (Форма.ЗапретитьРедактироватьФайлы И СозданПоШаблонуДокумента);
		РазрешеноУдаление = Не (Форма.ЗапретитьУдалятьФайлы И СозданПоШаблонуДокумента);
		
		УстановитьДоступностьКоманды(Элементы["КонтекстноеМенюФайлыОткрытьФайл"], Истина);
		УстановитьДоступностьКоманды(Элементы["КонтекстноеМенюФайлыНапечатать"], Истина);
		УстановитьДоступностьКоманды(Элементы["КонтекстноеМенюФайлыРедактировать"], 
			НЕ ТекущиеДанные.ПодписанЭП И РазрешеноРедактирование);
		УстановитьДоступностьКоманды(Элементы["КонтекстноеМенюФайлыЗакончитьРедактирование"], 
			РедактируетТекущийПользователь И РазрешеноРедактирование);
		УстановитьДоступностьКоманды(Элементы["КонтекстноеМенюФайлыИзменить"], Истина);
		УстановитьДоступностьКоманды(Элементы["КонтекстноеМенюФайлыСохранитьИзменения"],
			РедактируетТекущийПользователь И РазрешеноРедактирование);
		УстановитьДоступностьКоманды(Элементы["КонтекстноеМенюФайлыУдалить"], РазрешеноУдаление);
		УстановитьДоступностьКоманды(Элементы["КонтекстноеМенюФайлыСохранитьКак"], Истина);
		УстановитьДоступностьКоманды(Элементы["КонтекстноеМенюФайлыОбновитьИзФайлаНаДиске"], РазрешеноРедактирование);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьДоступностьКоманды(Команда, Доступность)
	
	Команда.Доступность = Доступность;
	
КонецПроцедуры

Процедура УстановитьДоступностьКомандМиникарточкиПоСостоянию(Форма, ДанныеМиникарточки) Экспорт
	
	ДанныеМиникарточки.Вставить("ОбщиеДоступныеПоля", "");
	ДанныеМиникарточки.Вставить("ОбщиеНедоступныеПоля", "");
	
	ДоступныеПоля = ДанныеМиникарточки.ДоступныеПоля;
	НедоступныеПоля = ДанныеМиникарточки.НедоступныеПоля;
	ИменаПолейИКомандДляНастройкиДоступности = ДанныеМиникарточки.ИменаПолейИКомандДляНастройкиДоступности;	
	
	Если ДанныеМиникарточки.ПолныеПрава Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ДанныеМиникарточки.ИспользоватьСостоянияДокументов Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ДанныеМиникарточки.ОграничиватьДоступностьПолейПоСостоянию Тогда 
		Возврат;
	КонецЕсли;
		
	ОбщиеНедоступныеПоля = Новый Структура;
	Для Каждого НедоступноеПоле Из НедоступныеПоля Цикл
		
		НайденнаяСтрока = Неопределено;
		Для Каждого Строка Из ИменаПолейИКомандДляНастройкиДоступности Цикл
			Если Строка.ИмяПоляКоманды = НедоступноеПоле Тогда 
				НайденнаяСтрока = Строка;
				Прервать;
			КонецЕсли;	
		КонецЦикла;	
		
		Если НайденнаяСтрока <> Неопределено Тогда 
			СтруктураПолей = Новый Структура(НайденнаяСтрока.ИменаПолейНаФорме);
			Для Каждого Поле Из СтруктураПолей Цикл
				ЭлементФормы = Форма.Элементы.Найти(Поле.Ключ);
				Если ЭлементФормы = Неопределено Тогда 
					Продолжить;
				КонецЕсли;
				Если ТипЗнч(ЭлементФормы) <> Тип("КнопкаФормы") 
				   И ТипЗнч(ЭлементФормы) <> Тип("ТаблицаФормы") Тогда 
					Продолжить;
				КонецЕсли;
				ОбщиеНедоступныеПоля.Вставить(Поле.Ключ);
				
				Если ТипЗнч(ЭлементФормы) = Тип("КнопкаФормы") Тогда 
					ЭлементФормы.Доступность = Ложь;
				Иначе
					ЭлементФормы.ТолькоПросмотр = Истина;
				КонецЕсли;
				
			КонецЦикла;	
		КонецЕсли;	
		
	КонецЦикла;	
	
	ОбщиеДоступныеПоля = Новый Структура;
	Для Каждого ДоступноеПоле Из ДоступныеПоля Цикл
		
		НайденнаяСтрока = Неопределено;
		Для Каждого Строка Из ИменаПолейИКомандДляНастройкиДоступности Цикл
			Если Строка.ИмяПоляКоманды = ДоступноеПоле Тогда 
				НайденнаяСтрока = Строка;
				Прервать;
			КонецЕсли;	
		КонецЦикла;
		
		Если НайденнаяСтрока <> Неопределено Тогда 
			СтруктураПолей = Новый Структура(НайденнаяСтрока.ИменаПолейНаФорме);
			СтруктураПолей.Вставить("ОткрытьФайл");
			СтруктураПолей.Вставить("КонтекстноеМенюФайлыОткрытьФайл");
			СтруктураПолей.Вставить("Напечатать");
			СтруктураПолей.Вставить("КонтекстноеМенюФайлыНапечатать");
			СтруктураПолей.Вставить("СохранитьКак");
			СтруктураПолей.Вставить("КонтекстноеМенюФайлыСохранитьКак");
			
			Для Каждого Поле Из СтруктураПолей Цикл
				ЭлементФормы = Форма.Элементы.Найти(Поле.Ключ);
				Если ЭлементФормы = Неопределено Тогда 
					Продолжить;
				КонецЕсли;
				Если ТипЗнч(ЭлементФормы) <> Тип("КнопкаФормы") 
				   И ТипЗнч(ЭлементФормы) <> Тип("ТаблицаФормы") Тогда 
					Продолжить;
				КонецЕсли;
				ОбщиеДоступныеПоля.Вставить(Поле.Ключ);
				
				Если ТипЗнч(ЭлементФормы) = Тип("КнопкаФормы") Тогда 
					ЭлементФормы.Доступность = Истина;
				Иначе
					ЭлементФормы.ТолькоПросмотр = Ложь;
				КонецЕсли;
				
			КонецЦикла;	
		КонецЕсли;
		
	КонецЦикла;	
	
	Если ДоступныеПоля.Найти("ДобавлениеОригиналов") <> Неопределено Тогда 
		ОбщиеДоступныеПоля.Вставить("СоздатьФайлОригинал");
	КонецЕсли;	
		
	Если ДоступныеПоля.Найти("ДобавлениеФайлов") <> Неопределено Тогда 
		ОбщиеДоступныеПоля.Вставить("СоздатьФайлОбычный");
	КонецЕсли;
	
	
	ТаблицаФайлы = Форма.Элементы.Найти("Файлы");
	Если ТаблицаФайлы = Неопределено Или ТипЗнч(ТаблицаФайлы) <> Тип("ТаблицаФормы") Тогда 
		ТаблицаФайлы = Форма.Элементы.Найти("ФайлыДокумента");
	КонецЕсли;
		
	Если ТаблицаФайлы <> Неопределено И ТипЗнч(ТаблицаФайлы) = Тип("ТаблицаФормы") Тогда 
	
		Если ОбщиеДоступныеПоля.Количество() = 0 И ОбщиеНедоступныеПоля.Количество() = 0 Тогда 
			ТаблицаФайлы.ИзменятьСоставСтрок = Истина;
		Иначе	
			Если Не ОбщиеДоступныеПоля.Свойство("КонтекстноеМенюФайлыСоздать") Тогда 
				ТаблицаФайлы.ИзменятьСоставСтрок = Ложь;
			Иначе	
				ТаблицаФайлы.ИзменятьСоставСтрок = Истина;
			КонецЕсли;
		КонецЕсли;
	
	КонецЕсли;
	
	ДанныеМиникарточки.Вставить("ОбщиеДоступныеПоля", ОбщиеДоступныеПоля);
	ДанныеМиникарточки.Вставить("ОбщиеНедоступныеПоля", ОбщиеНедоступныеПоля);
	
КонецПроцедуры	