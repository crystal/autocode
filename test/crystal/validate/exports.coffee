crystal = require '../../../src/crystal'

describe 'crystal', () ->
  describe 'validate', () ->
    describe 'exports', () ->
      it 'should be optional', () ->
        (-> new crystal {})
          .should.not.throw "`exports` is required."
        
      it 'should be a object', () ->
        # object
        config = {
          exports: {
            ConfigGenerator: {
              type: 'generator'
            }
          }
        }
        (-> new crystal config)
          .should.not.throw "`exports` must be a `object`, not a `object`."
        
        # true
        config = {
          exports: true
        }
        (-> new crystal config)
          .should.throw "`exports` must be a `object`, not a `boolean`."
          
        # false
        config = {
          exports: false
        }
        (-> new crystal config)
          .should.throw "`exports` must be a `object`, not a `boolean`."
    
      it 'should not require a description', () ->
        # object
        config = {
          exports: {
            ConfigGenerator: {
              type: 'generator'
            }
          }
        }
        (-> new crystal config)
          .should.not.throw "`exports.ConfigGenerator.description` is required."
      
      it 'should not require a engine', () ->
        # object
        config = {
          exports: {
            ConfigGenerator: {
              type: 'generator'
            }
          }
        }
        (-> new crystal config)
          .should.not.throw "`exports.ConfigGenerator.engine` is required."
      
      it 'should not require an example', () ->
        # object
        config = {
          exports: {
            ConfigGenerator: {
              type: 'generator'
            }
          }
        }
        (-> new crystal config)
          .should.not.throw "`exports.ConfigGenerator.example` is required."
      
      it 'should not require a filename', () ->
        # object
        config = {
          exports: {
            ConfigGenerator: {
              type: 'generator'
            }
          }
        }
        (-> new crystal config)
          .should.not.throw "`exports.ConfigGenerator.filename` is required."
      
      it 'should not require a helper', () ->
        # object
        config = {
          exports: {
            ConfigGenerator: {
              type: 'generator'
            }
          }
        }
        (-> new crystal config)
          .should.not.throw "`exports.ConfigGenerator.helper` is required."
      
      it 'should not require a schema', () ->
        # object
        config = {
          exports: {
            ConfigGenerator: {
              type: 'generator'
            }
          }
        }
        (-> new crystal config)
          .should.not.throw "`exports.ConfigGenerator.schema` is required."
      
      it 'should not require a spec', () ->
        # object
        config = {
          exports: {
            ConfigGenerator: {
              type: 'generator'
            }
          }
        }
        (-> new crystal config)
          .should.not.throw "`exports.ConfigGenerator.spec` is required."
      
      it 'should allow multiple modularized specs', () ->
        # object
        config = {
          exports: {
            ConfigGenerator: {
              spec: [
                'TestSpec2',
                'TestSpec1'
              ]
              type: 'generator'
            }
          }
        }
        (-> new crystal config)
          .should.not.throw "`exports.ConfigGenerator.spec` must be a `object` or `string`, not a `array`."
      
      it 'should not require a transformer', () ->
        # object
        config = {
          exports: {
            ConfigGenerator: {
              type: 'generator'
            }
          }
        }
        (-> new crystal config)
          .should.not.throw "`exports.ConfigGenerator.transformer` is required."
      
      it 'should require a type', () ->
        # object
        config = {
          exports: {
            ConfigGenerator: {}
          }
        }
        (-> new crystal config)
          .should.throw "`exports.ConfigGenerator.type` is required."