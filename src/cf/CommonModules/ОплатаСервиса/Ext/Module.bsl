﻿
#Область ПрограммныйИнтерфейс

// Возвращает состояния истечения сроков подписок на тарифы поданным менеджера сервиса.
// Данные возвращаются только для пользователей с ролью "Владелец абонента".
// @skip-warning ПустойМетод - особенность реализации.
//
// Возвращаемое значение:
//  Структура:
//   * ЗавершаетсяТестовых - Число
//   * ЗавершаетсяБесплатных - Число
//   * ЗавершаетсяПлатных - Число
//   * ЗавершаетсяВсего - Число
//   * НеЗавершаетсяТестовых - Число
//   * НеЗавершаетсяБесплатных - Число
//   * НеЗавершаетсяПлатных - Число
//   * НеЗавершаетсяВсего - Число
//
Функция СостоянияЗавершенияПодписокНаТарифы() Экспорт
КонецФункции

// См. ОбщегоНазначенияПереопределяемый.ПараметрыРаботыКлиентаПриЗапуске
// @skip-warning ПустойМетод - особенность реализации.
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
КонецПроцедуры

#КонецОбласти 

