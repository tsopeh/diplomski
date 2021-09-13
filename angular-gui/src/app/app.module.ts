import { CommonModule, registerLocaleData } from '@angular/common'
import { HttpClientModule } from '@angular/common/http'
import srLatin from '@angular/common/locales/sr-Latn'
import { LOCALE_ID, NgModule } from '@angular/core'
import { ReactiveFormsModule } from '@angular/forms'
import { BrowserModule } from '@angular/platform-browser'
import { BrowserAnimationsModule } from '@angular/platform-browser/animations'
import { AppRoutingModule } from './app-routing.module'
import { AppComponent } from './app.component'
import { LoadingSpinnerComponent } from './loading-spinner/loading-spinner.component'
import { LoadingUntilDirective } from './loading-until.directive'
import { ResultPageComponent } from './result-page/result-page.component'
import { SchedulePageComponent } from './schedule-page/schedule-page.component'
import { SearchPageComponent } from './search-page/search-page.component'
import { StationSelectComponent } from './search-page/station-select/station-select.component'

registerLocaleData(srLatin, 'sr-Latin')

@NgModule({
  declarations: [
    AppComponent,
    StationSelectComponent,
    SearchPageComponent,
    ResultPageComponent,
    SchedulePageComponent,
    LoadingUntilDirective,
    LoadingSpinnerComponent,
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    HttpClientModule,
    CommonModule,
    AppRoutingModule,
    ReactiveFormsModule,
  ],
  providers: [{ provide: LOCALE_ID, useValue: 'sr-Latin' }],
  bootstrap: [AppComponent],
})
export class AppModule {
}
