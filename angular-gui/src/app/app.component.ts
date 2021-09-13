import * as anim from '@angular/animations'
import { Component } from '@angular/core'
import { Router, RouterOutlet } from '@angular/router'

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
  animations: [
    anim.trigger('slideInOut', [
      anim.state('PAGE', anim.style({ transform: 'translateX(-100%)' })),
      anim.state('EMPTY', anim.style({ transform: 'translateX(100%)' })),
      anim.transition('EMPTY => PAGE', [
        anim.animate(260),
      ]),
      anim.transition('* => EMPTY', [
        anim.animate(126),
      ]),
    ]),
  ],
})
export class AppComponent {

  public readonly title = 'angular-gui'

  public constructor (
    private readonly router: Router,
  ) {
  }

  public prepareRoute (outlet: RouterOutlet): string {
    return outlet?.activatedRouteData?.animation ?? 'EMPTY'
  }

  public closeDrawer (): void {
    this.router.navigate(
      ['', { outlets: { drawer: null } }],
      { queryParamsHandling: 'merge' })
  }
}
