# =============================================================================
# 4. INDUSTRIAL BLUEPRINT LAYER: SITEWISE ASSET MODEL
# =============================================================================
resource "awscc_iotsitewise_asset_model" "gateway_model" {
  count = var.existing_asset_model_id == "" ? 1 : 0

  asset_model_name        = "MiniPC_Industrial_Gateway_Model"
  asset_model_description = "Defines structured metrics and hardware measurements for MiniPC deployments"

  asset_model_properties = [
    {
      name       = "LatestVideoClipUrl"
      logical_id = "latest_video_clip_url"
      data_type  = "STRING"
      unit       = "None"
      type = {
        type_name   = "Measurement"
        measurement = {}
      }
    },
    {
      name       = "Temperature_Sensor_1"
      logical_id = "temperature_sensor_1"
      data_type  = "DOUBLE"
      unit       = "Celsius"
      type = {
        type_name   = "Measurement"
        measurement = {}
      }
    },
    {
      name       = "Temperature_Sensor_2"
      logical_id = "temperature_sensor_2"
      data_type  = "DOUBLE"
      unit       = "Celsius"
      type = {
        type_name   = "Measurement"
        measurement = {}
      }
    },
    {
      name       = "Temperature_Sensor_3"
      logical_id = "temperature_sensor_3"
      data_type  = "DOUBLE"
      unit       = "Celsius"
      type = {
        type_name   = "Measurement"
        measurement = {}
      }
    },
    {
      name       = "Temperature_Sensor_4"
      logical_id = "temperature_sensor_4"
      data_type  = "DOUBLE"
      unit       = "Celsius"
      type = {
        type_name   = "Measurement"
        measurement = {}
      }
    },
    {
      name       = "Temperature_Sensor_5"
      logical_id = "temperature_sensor_5"
      data_type  = "DOUBLE"
      unit       = "Celsius"
      type = {
        type_name   = "Measurement"
        measurement = {}
      }
    },
    {
      name       = "Temperature_Sensor_6"
      logical_id = "temperature_sensor_6"
      data_type  = "DOUBLE"
      unit       = "Celsius"
      type = {
        type_name   = "Measurement"
        measurement = {}
      }
    },
    {
      name       = "Temperature_Sensor_7"
      logical_id = "temperature_sensor_7"
      data_type  = "DOUBLE"
      unit       = "Celsius"
      type = {
        type_name   = "Measurement"
        measurement = {}
      }
    },
    {
      name       = "Temperature_Sensor_8"
      logical_id = "temperature_sensor_8"
      data_type  = "DOUBLE"
      unit       = "Celsius"
      type = {
        type_name   = "Measurement"
        measurement = {}
      }
    },
    {
      name       = "Temperature_Sensor_9"
      logical_id = "temperature_sensor_9"
      data_type  = "DOUBLE"
      unit       = "Celsius"
      type = {
        type_name   = "Measurement"
        measurement = {}
      }
    },
    {
      name       = "Temperature_Sensor_10"
      logical_id = "temperature_sensor_10"
      data_type  = "DOUBLE"
      unit       = "Celsius"
      type = {
        type_name   = "Measurement"
        measurement = {}
      }
    }
  ]
}

# =============================================================================
# 5. PHYSICAL INDUSTRIAL TWIN LAYER: ASSET INSTANCE
# =============================================================================
resource "awscc_iotsitewise_asset" "gateway_instance" {
  count = var.existing_asset_id == "" ? 1 : 0

  asset_name     = "MiniPC_Unit_001"
  asset_model_id = var.existing_asset_model_id != "" ? var.existing_asset_model_id : awscc_iotsitewise_asset_model.gateway_model[0].asset_model_id
}