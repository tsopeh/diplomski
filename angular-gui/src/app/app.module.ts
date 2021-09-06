import { NgModule } from '@angular/core'
import { ReactiveFormsModule } from '@angular/forms'
import { BrowserModule } from '@angular/platform-browser'
import { AppRoutingModule } from './app-routing.module'
import { AppComponent } from './app.component'
import { ResultPageComponent } from './result-page/result-page.component'
import { StationSelectComponent } from './search-page/station-select/station-select.component'
import { SearchPageComponent } from './search-page/search-page.component';

@NgModule({
  declarations: [
    AppComponent,
    StationSelectComponent,
    SearchPageComponent,
    ResultPageComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    ReactiveFormsModule,
  ],
  providers: [],
  bootstrap: [AppComponent],
})
export class AppModule {
}
