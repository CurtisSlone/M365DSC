# Microsoft 365 DSC Configuration Management

Automated Microsoft 365 tenant configuration management using PowerShell Desired State Configuration (DSC) and GitHub Actions CI/CD pipeline. This solution enforces security baselines, maintains compliance with regulatory frameworks, and provides continuous drift detection.

## Overview

This project provides infrastructure-as-code management for Microsoft 365 tenants using [Microsoft365DSC](https://microsoft365dsc.com/). It enables you to define your desired M365 configuration declaratively and automatically deploy changes through a CI/CD pipeline while maintaining alignment with security compliance frameworks.

### Key Features

- **Declarative Configuration**: Define M365 settings in PowerShell data files
- **Automated Deployment**: GitHub Actions workflow builds and deploys configurations on push to main
- **Multi-Workload Support**: Manages Exchange, Teams, SharePoint, Azure AD, Intune, and more
- **Compliance Monitoring**: Built-in compliance checking with email/Teams notifications
- **Drift Detection**: Continuous monitoring to detect unauthorized configuration changes
- **Security Baseline Enforcement**: Automated enforcement of organizational security policies
- **Service Principal Automation**: Terraform modules for creating properly-scoped service principals

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        GitHub Repository                         │
├─────────────────────────────────────────────────────────────────┤
│  Datafiles/           Configuration data (.psd1)                │
│  M365Config/          Composite DSC resources                   │
│  M365Configuration.ps1  Main DSC configuration                  │
│  build.ps1            MOF compilation script                    │
│  deploy.ps1           Deployment script                         │
│  checkdsccompliancy.ps1  Drift detection script                 │
└──────────────────────────────┬──────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                      GitHub Actions Workflow                     │
│  1. Checkout repository                                         │
│  2. Build MOF files (build.ps1)                                 │
│  3. Deploy to M365 tenant (deploy.ps1)                          │
│  4. Scheduled drift detection (checkdsccompliancy.ps1)          │
└──────────────────────────────┬──────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Microsoft 365 Tenant                         │
│  Exchange │ Teams │ SharePoint │ Azure AD │ Intune │ OneDrive   │
└─────────────────────────────────────────────────────────────────┘
```

## CI/CD Pipeline Integration

### How the Pipeline Works

The GitHub Actions workflow (`.github/workflows/build.yaml`) implements a complete CI/CD pipeline for M365 configuration management:

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Commit to  │────▶│    Build     │────▶│   Deploy     │────▶│   M365       │
│   main       │     │   MOF Files  │     │   Config     │     │   Tenant     │
└──────────────┘     └──────────────┘     └──────────────┘     └──────────────┘
                            │                    │
                            ▼                    ▼
                     ┌──────────────┐     ┌──────────────┐
                     │  Validation  │     │   Audit      │
                     │  & Testing   │     │   Logging    │
                     └──────────────┘     └──────────────┘
```

#### Pipeline Stages

**1. Trigger (on push to main)**
```yaml
on:
  push:
    branches:
      - main
```

**2. Build Stage (`build.ps1`)**
- Validates Microsoft365DSC module version
- Installs required dependencies
- Compiles DSC configurations into MOF files
- Validates configuration syntax and references

**3. Deploy Stage (`deploy.ps1`)**
- Authenticates using service principal credentials
- Applies MOF configuration to M365 tenant
- Reports success/failure status

#### GitHub Secrets Configuration

Configure the following secrets in your GitHub repository (Settings → Secrets and variables → Actions):

| Secret | Description | Usage |
|--------|-------------|-------|
| `CLIENT_ID` | Service principal application (client) ID | Authentication to M365 |
| `CLIENT_SECRET` | Service principal client secret | Authentication to M365 |

#### Workflow Definition

```yaml
name: Build and Deploy MOF

on:
  push:
    branches:
      - main

jobs:
  job1:
    runs-on: windows-latest
    name: Build MOF
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Get Creds, Build, Deploy
        shell: powershell
        run: |
          $username = "${{secrets.CLIENT_ID}}"
          $password = ConvertTo-SecureString "${{secrets.CLIENT_SECRET}}" -AsPlainText -Force
          $psCreds = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)
          .\build.ps1 -AdminCreds $psCreds
          .\deploy.ps1 -Environment Production
```

#### Extending the Pipeline

To add additional stages (e.g., scheduled compliance checks):

```yaml
# Add to .github/workflows/build.yaml or create a new workflow
name: Compliance Check

on:
  schedule:
    - cron: '0 6 * * *'  # Daily at 6 AM UTC

jobs:
  compliance:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Compliance Check
        run: .\checkdsccompliancy.ps1
```

## Security Configuration Enforcement

### How Security is Enforced

This solution enforces security configurations through a **desired state model**:

1. **Define**: Security requirements are codified in `.psd1` data files
2. **Compile**: DSC compiles these into machine-readable MOF files
3. **Apply**: Configuration is pushed to M365, overwriting non-compliant settings
4. **Monitor**: Drift detection identifies unauthorized changes
5. **Remediate**: Pipeline automatically re-applies compliant configuration

### Security Controls Implemented

#### Authentication & Access Control

| Configuration | Security Benefit |
|--------------|------------------|
| `ActivationReqMFA = $true` | Requires MFA for PIM role activation |
| `AutoAdmittedUsers = "EveryoneInCompanyExcludingGuests"` | Restricts Teams meeting auto-admit |
| `AllowAnonymousUsersToStartMeeting = $false` | Prevents anonymous meeting initiation |
| `DisableAnonymousJoin = $false` | Controls anonymous access to meetings |
| `AllowGuestUser = $true` (controlled) | Managed guest access with restrictions |

#### Data Protection

| Configuration | Security Benefit |
|--------------|------------------|
| `AllowCloudRecording = $false` | Prevents unauthorized recording |
| `EnableSafeDocs = $true` | Enables Safe Documents for ATP |
| `EnableATPForSPOTeamsODB = $true` | ATP protection for SharePoint/OneDrive |
| DLP Policies (U.S. Financial Data) | Prevents sensitive data exfiltration |
| Sensitivity Labels | Information classification enforcement |

#### Email Security

| Configuration | Security Benefit |
|--------------|------------------|
| DKIM Signing (`Enabled = $true`) | Email authentication |
| `EwsApplicationAccessPolicy = "EnforceBlockList"` | Controls EWS application access |
| `AuditDisabled = $False` | Ensures audit logging is active |

#### Platform Hardening

| Configuration | Security Benefit |
|--------------|------------------|
| `LegacyAuthProtocolsEnabled = $false` | Blocks legacy authentication |
| `DisableEnvironmentCreationByNonAdminUsers = $True` | Restricts Power Platform environment creation |
| `AllowBox/DropBox/GoogleDrive = $False` | Restricts third-party cloud storage |
| `SecurityBlockJailbrokenDevices = $True` | Blocks compromised iOS devices |

#### Privileged Access Management

| Configuration | Security Benefit |
|--------------|------------------|
| `PermanentActiveAssignmentisExpirationRequired = $true` | Time-limited privileged access |
| `ExpireActiveAssignment = "P15D"` | 15-day maximum for active assignments |
| `ActivationReqJustification = $true` | Requires justification for elevation |
| Alert notifications to security team | Real-time privileged access monitoring |

### Example: Exchange Security Configuration

```powershell
EXOOrganizationConfig 'EXOOrganizationConfig'
{
    AuditDisabled                  = $False           # Ensure auditing enabled
    AutoExpandingArchive           = $False           # Control archive expansion
    DefaultGroupAccessType         = "Private"        # Private groups by default
    EwsApplicationAccessPolicy     = "EnforceBlockList"  # Control EWS access
    OAuth2ClientProfileEnabled     = $True            # Modern auth enabled
}
```

### Example: Azure AD PIM Configuration

```powershell
AADRoleSetting 'Global Administrator'
{
    ActivationReqMFA                              = $true   # Require MFA
    ActivationReqJustification                    = $true   # Require justification
    PermanentActiveAssignmentisExpirationRequired = $true   # No permanent access
    ExpireActiveAssignment                        = "P15D"  # 15-day max
    ActiveAlertNotificationAdditionalRecipient    = "security_notifications@domain.com"
}
```

## Compliance Control Mapping

This solution supports compliance with multiple regulatory frameworks. Below are mappings to NIST 800-171 control families.

### NIST 800-171 Control Family Mapping

#### Access Control (AC)

| Control | Description | Implementation |
|---------|-------------|----------------|
| **AC-2** | Account Management | Azure AD role settings with time-limited assignments, PIM policies requiring justification and approval |
| **AC-3** | Access Enforcement | Teams policies restricting meeting access, SharePoint conditional access policies |
| **AC-5** | Separation of Duties | Separate service principals per workload with least-privilege permissions |
| **AC-6** | Least Privilege | PIM role settings with `ExpireActiveAssignment`, `ExpireEligibleAssignment` |
| **AC-7** | Unsuccessful Logon Attempts | Azure AD authentication policies (configured via Conditional Access) |
| **AC-11** | Session Lock | `ActivityBasedAuthenticationTimeoutEnabled = $True` with 6-hour timeout |
| **AC-17** | Remote Access | Teams guest policies, external sharing restrictions in SharePoint/OneDrive |
| **AC-19** | Access Control for Mobile | Intune compliance policies (`SecurityBlockJailbrokenDevices = $True`) |
| **AC-20** | Use of External Systems | `AllowBox/DropBox/GoogleDrive = $False` in Teams client configuration |

#### Identification and Authentication (IA)

| Control | Description | Implementation |
|---------|-------------|----------------|
| **IA-2** | Identification and Authentication | `ActivationReqMFA = $true` for privileged roles, Azure AD authentication policies |
| **IA-2(1)** | MFA for Network Access | MFA required for PIM activation |
| **IA-2(2)** | MFA for Local Access | Intune device compliance requiring passcode |
| **IA-4** | Identifier Management | Service principal lifecycle managed via Terraform with rotation |
| **IA-5** | Authenticator Management | `service_principal_password_rotation_in_years = 1` for credential rotation |
| **IA-8** | Identification of Non-Org Users | Guest user policies in Teams, SharePoint external sharing controls |

#### System and Communications Protection (SC)

| Control | Description | Implementation |
|---------|-------------|----------------|
| **SC-7** | Boundary Protection | Exchange inbound/outbound connectors, Teams federation settings |
| **SC-8** | Transmission Confidentiality | `RequireTls = $true` on Exchange connectors, DKIM signing enabled |
| **SC-13** | Cryptographic Protection | DKIM with 1024-bit keys, TLS enforcement |
| **SC-23** | Session Authenticity | OAuth2 enabled, legacy auth disabled (`LegacyAuthProtocolsEnabled = $false`) |
| **SC-28** | Protection of Information at Rest | Sensitivity labels with encryption capabilities |

#### System and Information Integrity (SI)

| Control | Description | Implementation |
|---------|-------------|----------------|
| **SI-2** | Flaw Remediation | Automated configuration enforcement via CI/CD pipeline |
| **SI-3** | Malicious Code Protection | `EnableATPForSPOTeamsODB = $True`, Safe Documents enabled |
| **SI-4** | System Monitoring | `AuditDisabled = $False`, PIM alert notifications |
| **SI-7** | Software and Information Integrity | DSC drift detection, configuration-as-code with version control |

### Additional Framework Mappings

#### CIS Microsoft 365 Benchmarks

| CIS Control | Implementation |
|-------------|----------------|
| 1.1.1 - Enable MFA | PIM `ActivationReqMFA = $true` |
| 2.1 - Block legacy auth | `LegacyAuthProtocolsEnabled = $false` |
| 3.1 - Enable audit logging | `AuditDisabled = $False` |
| 5.2 - Enable ATP | `EnableATPForSPOTeamsODB = $True` |

#### FedRAMP / FISMA

The NIST 800-171 mappings above provide substantial coverage for FedRAMP Moderate baseline requirements, particularly in AC, IA, SC, and SI families.

### Compliance Evidence Generation

The `checkdsccompliancy.ps1` script generates compliance reports suitable for audit evidence:

```powershell
# Report includes:
# - Timestamp of compliance check
# - Environment tested
# - Resources in desired state
# - Resources NOT in desired state (with details)
# - Overall compliance status
```

## Drift Detection

### How Drift Detection Works

Drift occurs when the actual M365 configuration deviates from the desired state defined in code. This can happen through:

- Manual changes in admin portals
- Changes via PowerShell/API outside the pipeline
- Microsoft service updates
- Malicious configuration changes

```
┌─────────────────────────────────────────────────────────────────┐
│                     Drift Detection Process                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌──────────────┐                    ┌──────────────┐         │
│   │   Desired    │                    │   Actual     │         │
│   │    State     │◄───── Compare ────▶│    State     │         │
│   │  (MOF File)  │                    │  (M365 API)  │         │
│   └──────────────┘                    └──────────────┘         │
│          │                                   │                  │
│          └─────────────┬─────────────────────┘                  │
│                        ▼                                        │
│               ┌──────────────┐                                  │
│               │    Drift     │                                  │
│               │   Report     │                                  │
│               └──────────────┘                                  │
│                        │                                        │
│          ┌─────────────┼─────────────┐                         │
│          ▼             ▼             ▼                         │
│   ┌──────────┐  ┌──────────┐  ┌──────────┐                    │
│   │  Email   │  │  Teams   │  │ Pipeline │                    │
│   │  Alert   │  │  Alert   │  │  Trigger │                    │
│   └──────────┘  └──────────┘  └──────────┘                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Running Drift Detection

#### Manual Execution

```powershell
.\checkdsccompliancy.ps1
```

#### Scheduled Execution (Recommended)

Add a scheduled workflow to run drift detection regularly:

```yaml
# .github/workflows/drift-detection.yaml
name: Drift Detection

on:
  schedule:
    - cron: '0 */4 * * *'  # Every 4 hours
  workflow_dispatch:        # Allow manual trigger

jobs:
  check-drift:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Install Dependencies
        shell: powershell
        run: |
          $modules = Import-PowerShellDataFile -Path 'DscResources.psd1'
          Install-Module -Name 'Microsoft365Dsc' -RequiredVersion $modules.Microsoft365Dsc -Force
          Update-M365DSCDependencies
          
      - name: Run Compliance Check
        shell: powershell
        run: .\checkdsccompliancy.ps1
        env:
          MAIL_APP_ID: ${{ secrets.MAIL_APP_ID }}
          MAIL_APP_SECRET: ${{ secrets.MAIL_APP_SECRET }}
          TEAMS_WEBHOOK: ${{ secrets.TEAMS_WEBHOOK }}
```

### Drift Detection Output

The compliance check produces detailed reports:

```
************************************************************
*          Testing compliancy on all environments          *
************************************************************
Processing all MOF files in 'C:\...\Output'
- Found 1 files
  * Processing Production
    - InDesiredState: False
    - ErrorCount: 2
    - ErroredResources: 
        [TeamsMeetingPolicy]MeetingPolicy_Global
        [EXOOrganizationConfig]EXOOrganizationConfig
```

### Notification Configuration

Configure alerts in `checkdsccompliancy.ps1`:

```powershell
# Email Notifications
$useMail = $true
$mailAppId = '<APP_ID>'
$mailAppSecret = '<SECRET>'
$mailTenantId = '<TENANT_ID>'
$mailFrom = 'dsc-alerts@yourdomain.com'
$mailTo = 'security-team@yourdomain.com'

# Teams Notifications
$useTeams = $true
$teamsWebhook = 'https://outlook.office.com/webhook/...'
```

### Automated Remediation

When drift is detected, you have two remediation options:

**Option 1: Manual Review (Recommended for Production)**
1. Review drift report
2. Investigate cause of drift
3. Update code if change is legitimate
4. Re-run pipeline to enforce desired state

**Option 2: Automatic Remediation**
Add auto-remediation to the drift detection workflow:

```yaml
- name: Auto-Remediate Drift
  if: failure()  # Only if drift detected
  shell: powershell
  run: |
    $creds = # ... setup credentials
    .\deploy.ps1 -Environment Production
```

> ⚠️ **Warning**: Automatic remediation should be used carefully. Always investigate drift causes before enabling auto-remediation.

### Drift Detection Best Practices

1. **Run frequently**: Schedule checks every 4-6 hours minimum
2. **Alert immediately**: Configure real-time notifications for security team
3. **Investigate all drift**: Treat unexpected drift as a potential security incident
4. **Document exceptions**: If drift is intentional, update the desired state in code
5. **Correlate with logs**: Cross-reference drift with Azure AD audit logs

## Prerequisites

- Microsoft 365 tenant with appropriate licenses
- GitHub repository with Actions enabled
- Service principal(s) with required permissions (see [Service Principal Setup](#service-principal-setup))
- PowerShell 5.1+ (workflow runs on `windows-latest`)

## Project Structure

```
.
├── .github/
│   └── workflows/
│       └── build.yaml              # CI/CD pipeline definition
├── Datafiles/
│   └── Production.psd1             # Environment configuration data
├── M365Config/
│   └── 1.0.0/
│       ├── M365Config.psd1         # Module manifest
│       └── DscResources/
│           ├── AzureAD/            # Azure AD configuration
│           ├── Exchange/           # Exchange Online configuration
│           ├── Intune/             # Intune configuration
│           ├── Office365/          # Office 365 settings
│           ├── OneDrive/           # OneDrive configuration
│           ├── PowerPlatform/      # Power Platform settings
│           ├── SecurityCompliance/ # Security & Compliance settings
│           ├── SharePoint/         # SharePoint Online configuration
│           └── Teams/              # Microsoft Teams configuration
├── dscspn/                         # Terraform for service principals
│   ├── spn-module/                 # Reusable SPN module
│   └── modules.*.spn.tf            # Workload-specific SPN definitions
├── M365Configuration.ps1           # Main DSC configuration
├── DscResources.psd1               # Microsoft365DSC version pinning
├── build.ps1                       # MOF compilation script
├── deploy.ps1                      # Deployment script
└── checkdsccompliancy.ps1          # Drift detection script
```

## Configuration

### Environment Data Files

Environment-specific configurations are stored in `Datafiles/*.psd1`. Each file defines settings for a specific environment (e.g., Production, Development).

```powershell
# Datafiles/Production.psd1
@{
    AllNodes = @(
        @{
            NodeName                    = 'localhost'
            PsDscAllowPlainTextPassword = $true
            PsDscAllowDomainUser        = $true
        }
    )

    NonNodeData = @{
        Environment = @{
            Name             = 'Production'
            ShortName        = 'PRD'
            OrganizationName = "yourdomain.com"
            AlertName        = "security_notifications@yourdomain.com"
        }

        Accounts = @(
            @{ Workload = 'Exchange' }
            @{ Workload = 'Teams' }
            # ... additional workloads
        )

        Exchange = @{ ... }
        Teams    = @{ ... }
        AzureAD  = @{ ... }
    }
}
```

### Supported Workloads

| Workload | Description |
|----------|-------------|
| **Exchange** | Organization config, accepted domains, DKIM, connectors, mail tips |
| **Teams** | Meeting policies, guest settings, client configuration, emergency calling |
| **SharePoint** | Tenant settings, CDN configuration |
| **AzureAD** | PIM role settings, notifications |
| **Intune** | Device compliance policies |
| **Office365** | Org customization, audit log settings |
| **OneDrive** | Storage quotas, sharing settings |
| **PowerPlatform** | Environment creation policies, tenant settings |
| **SecurityCompliance** | DLP policies, sensitivity labels |

### Version Pinning

The Microsoft365DSC module version is pinned in `DscResources.psd1`:

```powershell
@{
    Microsoft365DSC = '1.22.1019.1'
}
```

Update this version carefully and test thoroughly before deploying to production.

## Service Principal Setup

### Using Terraform (Recommended)

The `dscspn/` directory contains Terraform configurations to create properly-scoped service principals for each M365 workload.

```bash
cd dscspn

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply
```

This creates separate service principals with least-privilege permissions:

| Service Principal | Purpose | Key Permissions |
|-------------------|---------|-----------------|
| `dsc_aad_spn` | Azure AD management | Directory.ReadWrite.All, RoleManagement.ReadWrite.Directory |
| `dsc_exchange_spn` | Exchange Online | Exchange Administrator role |
| `dsc_teams_spn` | Teams management | Teams Administrator role |
| `dsc_sharepoint_spn` | SharePoint management | SharePoint Administrator role |
| `dsc_intune_spn` | Intune management | Intune Administrator role |
| `dsc_o365_spn` | Office 365 | Groups Administrator role |
| `dsc_OD_spn` | OneDrive | Sites.FullControl.All |
| `dsc_platform_spn` | Power Platform | Contributor role |
| `dsc_security_compliance_spn` | Security & Compliance | Security Administrator role |

## Local Development

### Building MOF Files Locally

```powershell
# Run as Administrator
$creds = Get-Credential
.\build.ps1 -AdminCreds $creds
```

### Testing Deployment

```powershell
.\deploy.ps1 -Environment Production
```

### Checking Compliance

```powershell
# Configure notification settings in the script first
.\checkdsccompliancy.ps1
```

## Adding New Configurations

### 1. Update Data File

Add configuration data to the appropriate section in `Datafiles/Production.psd1`:

```powershell
Teams = @{
    MeetingPolicies = @(
        @{
            Identity = "CustomPolicy"
            AllowCloudRecording = $true
            # ... additional settings
        }
    )
}
```

### 2. Update DSC Resource (if needed)

If adding a new resource type, update the corresponding schema file in `M365Config/1.0.0/DscResources/`:

```powershell
# M365Config/1.0.0/DscResources/Teams/Teams.schema.psm1
foreach ($MeetingPolicy in $ConfigurationData.NonNodeData.Teams.MeetingPolicies)
{
    TeamsMeetingPolicy "MeetingPolicy_$($MeetingPolicy.Identity)"
    {
        Identity = $MeetingPolicy.Identity
        # ... map properties
    }
}
```

### 3. Commit and Push

```bash
git add .
git commit -m "Add new Teams meeting policy"
git push origin main
```

The GitHub Actions workflow will automatically build and deploy the changes.

## Troubleshooting

### Common Issues

**MOF Compilation Fails**
- Verify Microsoft365DSC module version matches `DscResources.psd1`
- Check PowerShell execution policy: `Set-ExecutionPolicy Unrestricted -Force`
- Ensure all required modules are installed

**Deployment Authentication Errors**
- Verify service principal credentials in GitHub secrets
- Check service principal has required permissions
- Ensure admin consent is granted for Graph API permissions

**Compliance Check Failures**
- Review the detailed error output in the compliance report
- Check if the resource was manually modified in the tenant
- Verify the configuration data matches the expected schema

**Drift Detection Shows False Positives**
- Ensure Microsoft365DSC version matches between build and check
- Some M365 settings have eventual consistency; re-run after a few minutes
- Check for settings that Microsoft auto-modifies

### Logs

- GitHub Actions logs: Repository → Actions → Select workflow run
- Local logs: Scripts output timestamped messages to console

## Security Considerations

1. **Protect Secrets**: Never commit credentials to the repository
2. **Least Privilege**: Use workload-specific service principals
3. **Audit Access**: Monitor service principal sign-ins in Azure AD
4. **Review Changes**: Require pull request reviews for configuration changes
5. **Test First**: Use a development tenant before applying to production

## Resources

- [Microsoft365DSC Documentation](https://microsoft365dsc.com/)
- [Microsoft365DSC GitHub](https://github.com/microsoft/Microsoft365DSC)
- [DSC Resource Reference](https://microsoft365dsc.com/user-guide/get-started/resources/)
- [NIST 800-171 Publication](https://csrc.nist.gov/publications/detail/sp/800-171/rev-2/final)
- [CIS Microsoft 365 Benchmarks](https://www.cisecurity.org/benchmark/microsoft_365)
- [Azure AD Service Principal Permissions](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-permissions-and-consent)

## License

This project is provided as-is. See individual file headers for any specific licensing information.
