﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет показатели виджетов.
//
Процедура ЗаполнитьПоказатели() Экспорт
	
	// Заполнение показателей для виджета Мои задачи
	Показатель = Справочники.ПоказателиВиджетов.МоиЗадачи.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.МоиЗадачи;
	Показатель.ПороговоеЗначение = 15;
	Показатель.Порядок = 1;
	Показатель.Записать();
	
	Показатель = Справочники.ПоказателиВиджетов.МоиЗадачи_НеПринятые.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.МоиЗадачи;
	Показатель.ПороговоеЗначение = 10;
	Показатель.Порядок = 2;
	Показатель.Записать();
	
	Показатель = Справочники.ПоказателиВиджетов.МоиЗадачи_Просроченные.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.МоиЗадачи;
	Показатель.ПороговоеЗначение = 5;
	Показатель.Порядок = 3;
	Показатель.Записать();
	
	// Заполнение показателей для виджета Задачи отдела
	Показатель = Справочники.ПоказателиВиджетов.ЗадачиОтдела.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.ЗадачиОтдела;
	Показатель.ПороговоеЗначение = 45;
	Показатель.Порядок = 1;
	Показатель.Записать();
	
	Показатель = Справочники.ПоказателиВиджетов.ЗадачиОтдела_НеПринятые.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.ЗадачиОтдела;
	Показатель.ПороговоеЗначение = 30;
	Показатель.Порядок = 2;
	Показатель.Записать();
	
	Показатель = Справочники.ПоказателиВиджетов.ЗадачиОтдела_Просроченные.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.ЗадачиОтдела;
	Показатель.ПороговоеЗначение = 15;
	Показатель.Порядок = 3;
	Показатель.Записать();
	
	// Заполнение показателей для виджета Мои документы
	Показатель = Справочники.ПоказателиВиджетов.МоиДокументы.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.МоиДокументы;
	Показатель.ПороговоеЗначение = 20;
	Показатель.Порядок = 1;
	Показатель.Записать();
	
	Показатель = Справочники.ПоказателиВиджетов.МоиДокументы_Просроченные.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.МоиДокументы;
	Показатель.Порядок = 2;
	Показатель.ПороговоеЗначение = 5;
	Показатель.Записать();
	
	Показатель = Справочники.ПоказателиВиджетов.МоиДокументы_ВходящиеБезОтвета.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.МоиДокументы;
	Показатель.ПороговоеЗначение = 5;
	Показатель.Порядок = 3;
	Показатель.Записать();
	
	Показатель = Справочники.ПоказателиВиджетов.МоиДокументы_ВнутренниеСИстекающимСрокомДействия_Исполнения.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.МоиДокументы;
	Показатель.ПороговоеЗначение = 5;
	Показатель.Порядок = 4;
	Показатель.Записать();
	
	// Заполнение показателей для виджета СВД
	Показатель = Справочники.ПоказателиВиджетов.СВД_ГотовыеКОтправке.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.СВД;
	Показатель.ПороговоеЗначение = 0;
	Показатель.Порядок = 1;
	Показатель.Записать();
	
	Показатель = Справочники.ПоказателиВиджетов.СВД_ЗагруженныеНаПроверку.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.СВД;
	Показатель.ПороговоеЗначение = 5;
	Показатель.Порядок = 2;
	Показатель.Записать();
	
	Показатель = Справочники.ПоказателиВиджетов.СВД_СОшибкой.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.СВД;
	Показатель.ПороговоеЗначение = 3;
	Показатель.Порядок = 3;
	Показатель.Записать();
	
	// Заполнение показателей для виджета Мои файлы
	Показатель = Справочники.ПоказателиВиджетов.МоиФайлы_РедактируемыеФайлы.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.МоиФайлы;
	Показатель.ПороговоеЗначение = 3;
	Показатель.Порядок = 1;
	Показатель.Записать();
	
	// Заполнение показателей для виджета Мероприятия
	Показатель = Справочники.ПоказателиВиджетов.Мероприятия.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.Мероприятия;
	Показатель.ПороговоеЗначение = 3;
	Показатель.Порядок = 1;
	Показатель.Записать();
	
	// Заполнение показателей для виджета Календарь
	Показатель = Справочники.ПоказателиВиджетов.Календарь.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.Календарь;
	Показатель.ПороговоеЗначение = 3;
	Показатель.Порядок = 1;
	Показатель.Записать();
	
	// Заполнение показателей для виджета Форум
	Показатель = Справочники.ПоказателиВиджетов.Форум.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.Форум;
	Показатель.ПороговоеЗначение = 20;
	Показатель.Порядок = 1;
	Показатель.Записать();
	
	Показатель = Справочники.ПоказателиВиджетов.Форум_НовыеОтветыНаСообщенияПользователя.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.Форум;
	Показатель.ПороговоеЗначение = 5;
	Показатель.Порядок = 2;
	Показатель.Записать();
	
	// Заполнение показателей для виджета Контроль
	Показатель = Справочники.ПоказателиВиджетов.Контроль.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.Контроль;
	Показатель.ПороговоеЗначение = 20;
	Показатель.Порядок = 1;
	Показатель.Записать();
	
	Показатель = Справочники.ПоказателиВиджетов.Контроль_Просрочено.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.Контроль;
	Показатель.ПороговоеЗначение = 5;
	Показатель.Порядок = 2;
	Показатель.Записать();
	
	// Заполнение показателей для виджета Почта
	Показатель = Справочники.ПоказателиВиджетов.Почта.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.Почта;
	Показатель.ПороговоеЗначение = 10;
	Показатель.Порядок = 1;
	Показатель.Записать();
	
	Показатель = Справочники.ПоказателиВиджетов.Почта_УчетнаяЗапись.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.Почта;
	Показатель.ПороговоеЗначение = 10;
	Показатель.Порядок = 2;
	Показатель.Записать();
	
	// Заполнение показаталей для виджета Отсутствия
	Показатель = Справочники.ПоказателиВиджетов.Отсутствия.ПолучитьОбъект();
	Показатель.Виджет = Справочники.Виджеты.Отсутствия;
	Показатель.ПороговоеЗначение = 50;
	Показатель.Порядок = 1;
	Показатель.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли