import { NgModule } from '@angular/core'
import { RouterModule, Routes } from '@angular/router'
import { ResultPageComponent } from './result-page/result-page.component'
import { SchedulePageComponent } from './schedule-page/schedule-page.component'
import { SearchPageComponent } from './search-page/search-page.component'

const routes: Routes = [
  {
    path: '',
    pathMatch: 'full',
    component: SearchPageComponent,
  },
  {
    path: 'search',
    component: ResultPageComponent,
  },
  {
    outlet: 'drawer',
    path: 'schedule/:id',
    component: SchedulePageComponent,
    data: { animation: 'PAGE' },
  },
  {
    path: '**',
    redirectTo: '',
  },
]

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {
}
