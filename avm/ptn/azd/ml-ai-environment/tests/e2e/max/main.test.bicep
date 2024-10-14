targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module using large parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-azd-ml-ai-environment-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'maemax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      location: resourceLocation
      hubName: '${namePrefix}${serviceShort}hub001'
      keyVaultName: '${namePrefix}${serviceShort}kv001'
      cognitiveServicesName: '${namePrefix}${serviceShort}cs001'
      projectName: '${namePrefix}${serviceShort}pro001'
      storageAccountName: '${namePrefix}${serviceShort}sta001'
      userAssignedtName: '${namePrefix}${serviceShort}ua001'
      containerRegistryName: '${namePrefix}${serviceShort}cr001'
      applicationInsightsName: '${namePrefix}${serviceShort}appin001'
      logAnalyticsName: '${namePrefix}${serviceShort}la001'
      searchServiceName: '${namePrefix}${serviceShort}search001'
      openAiConnectionName: '${namePrefix}${serviceShort}ai001-connection'
      searchConnectionName: '${namePrefix}${serviceShort}search001-connection'
      cognitiveServicesDeployments: [
        {
          name: 'gpt-35-turbo'
          model: {
            name: 'gpt-35-turbo'
            format: 'OpenAI'
            version: '0613'
          }
          sku: {
            name: 'Standard'
            capacity: 20
          }
        }
      ]
    }
  }
]