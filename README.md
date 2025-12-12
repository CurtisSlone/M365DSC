# Microsoft 365 DSC Configuration Management

Automated Microsoft 365 tenant configuration management using PowerShell Desired State Configuration (DSC) and GitHub Actions CI/CD pipeline.

## Overview

This project provides infrastructure-as-code management for Microsoft 365 tenants using [Microsoft365DSC](https://microsoft365dsc.com/). It enables you to define your desired M365 configuration declaratively and automatically deploy changes through a CI/CD pipeline.

### Key Features

- **Declarative Configuration**: Define M365 settings in PowerShell data files
- **Automated Deployment**: GitHub Actions workflow builds and deploys configurations on push to main
- **Multi-Workload Support**: Manages Exchange, Teams, SharePoint, Azure AD, Intune, and more
- **Compliance Monitoring**: Built-in compliance checking with email/Teams notifications
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
└──────────────────────────────┬──────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                      GitHub Actions Workflow                     │
│  1. Checkout repository                                         │
│  2. Build MOF files (build.ps1)                                 │
│  3. Deploy to M365 tenant (deploy.ps1)                          │
└──────────────────────────────┬──────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Microsoft 365 Tenant                         │
│  Exchange │ Teams │ SharePoint │ Azure AD │ Intune │ OneDrive   │
└─────────────────────────────────────────────────────────────────┘
```

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
└── checkdsccompliancy.ps1          # Compliance monitoring script
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
            AlertName        = "alerts@yourdomain.com"
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

## GitHub Actions Setup

### Required Secrets

Configure the following secrets in your GitHub repository (Settings → Secrets and variables → Actions):

| Secret | Description |
|--------|-------------|
| `CLIENT_ID` | Service principal application (client) ID |
| `CLIENT_SECRET` | Service principal client secret |

### Workflow Trigger

The pipeline triggers automatically on push to the `main` branch:

```yaml
on:
  push:
    branches:
      - main
```

### Pipeline Steps

1. **Checkout**: Clones the repository
2. **Build**: Runs `build.ps1` to compile MOF files
3. **Deploy**: Runs `deploy.ps1` to apply configuration to M365 tenant

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

- `dsc_aad_spn` - Azure AD management
- `dsc_exchange_spn` - Exchange Online management
- `dsc_teams_spn` - Teams management
- `dsc_sharepoint_spn` - SharePoint management
- `dsc_intune_spn` - Intune management
- `dsc_o365_spn` - Office 365 management
- `dsc_OD_spn` - OneDrive management
- `dsc_platform_spn` - Power Platform management
- `dsc_security_compliance_spn` - Security & Compliance management
- `dsc_planner_spn` - Planner management

### Required Permissions by Workload

Each service principal requires specific Microsoft Graph permissions and directory roles. See the individual Terraform files in `dscspn/modules.*.spn.tf` for detailed permission requirements.

**Example - Exchange Service Principal:**
- Directory Roles: Exchange Administrator, Exchange Recipient Administrator, Security Administrator
- Graph Permissions: Policy.Read.All

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

## Compliance Monitoring

The `checkdsccompliancy.ps1` script tests M365 configurations against the desired state and sends reports via:

- **Email**: Configure `$mailAppId`, `$mailAppSecret`, `$mailTenantId`, `$mailFrom`, `$mailTo`
- **Teams**: Configure `$teamsWebhook` with an incoming webhook URL

Enable your preferred notification method:

```powershell
$useMail = $true   # or $false
$useTeams = $true  # or $false
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

### Logs

- GitHub Actions logs: Repository → Actions → Select workflow run
- Local logs: Scripts output timestamped messages to console

## Contributing

1. Create a feature branch from `main`
2. Make your changes
3. Test locally using `build.ps1`
4. Submit a pull request

## Resources

- [Microsoft365DSC Documentation](https://microsoft365dsc.com/)
- [Microsoft365DSC GitHub](https://github.com/microsoft/Microsoft365DSC)
- [DSC Resource Reference](https://microsoft365dsc.com/user-guide/get-started/resources/)
- [Azure AD Service Principal Permissions](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-permissions-and-consent)

## License

This project is provided as-is. See individual file headers for any specific licensing information.
