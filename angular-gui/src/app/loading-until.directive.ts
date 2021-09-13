import {
  ComponentFactoryResolver,
  Directive,
  Input,
  TemplateRef,
  ViewContainerRef,
} from '@angular/core'
import { LoadingSpinnerComponent } from './loading-spinner/loading-spinner.component'

@Directive({
  selector: '[loadingUntil]',
})
export class LoadingUntilDirective {

  private hasView: boolean = false
  private hasSpinner: boolean = false

  public constructor (
    private readonly templateRef: TemplateRef<any>,
    private readonly viewContainer: ViewContainerRef,
    private readonly factoryResolver: ComponentFactoryResolver,
  ) {
  }

  @Input() set loadingUntil (condition: boolean) {
    if (condition && !this.hasView) {
      this.viewContainer.clear()
      this.viewContainer.createEmbeddedView(this.templateRef)
      this.hasSpinner = false
      this.hasView = true
    } else if (!condition && !this.hasSpinner) {
      this.viewContainer.clear()
      this.viewContainer.createComponent(
        this.factoryResolver.resolveComponentFactory(LoadingSpinnerComponent),
      )
      this.hasSpinner = true
      this.hasView = false
    }
  }

  static ngTemplateGuard_loadingUntil: 'binding'

}
