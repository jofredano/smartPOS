import { Component, OnInit } from '@angular/core';
import { FirewallService } from '../../core/security/firewall.service';

@Component({
  selector: 'app-footer',
  templateUrl: './footer.component.html',
  styleUrls: []
})
export class FooterComponent implements OnInit {

  constructor(private firewallService: FirewallService) { }

  ngOnInit() {
    this.firewallService.clearObserverForLogin();
  }

}