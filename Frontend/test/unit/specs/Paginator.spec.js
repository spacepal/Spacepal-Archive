import Vue from 'vue'
import Paginator from '@/components/Paginator'
import { shallowMount } from '@vue/test-utils'


describe('Paginator.vue', () => {
  it('should render correct contents', () => {
    const wrapper = shallowMount(Paginator, {
      propsData: {
        total: 29,
        limit: 10
      }
    })
    expect(wrapper.find('.page').text()).toBe('1 of 3')
    expect(wrapper.vm.previousClass).toBe('disabled')
    expect(wrapper.vm.nextClass).toBe('')

    wrapper.vm.go(-1)
    expect(wrapper.find('.page').text()).toBe('1 of 3')
    expect(wrapper.vm.previousClass).toBe('disabled')
    expect(wrapper.vm.nextClass).toBe('')

    wrapper.vm.go(+1)
    expect(wrapper.find('.page').text()).toBe('2 of 3')
    expect(wrapper.vm.previousClass).toBe('')
    expect(wrapper.vm.nextClass).toBe('')

    wrapper.vm.go(+3)
    expect(wrapper.find('.page').text()).toBe('3 of 3')
    expect(wrapper.vm.previousClass).toBe('')
    expect(wrapper.vm.nextClass).toBe('disabled')

    wrapper.vm.go(-1)
    expect(wrapper.find('.page').text()).toBe('2 of 3')
    expect(wrapper.vm.previousClass).toBe('')
    expect(wrapper.vm.nextClass).toBe('')
  })
})
