//
//  UINavigationControllerExt.swift
//  Bolwala
//
//  Created by Bolwala on 03/07/2018.
//  Copyright © 2018 Bolwala. All rights reserved.
//

import UIKit

//MARK: - Animations
enum AnimationType {
    case fadeIn, fadeOut, flip
}

enum TransitionType {
    case fade, moveIn, push, reveal, flip, box
}

extension UINavigationController {
    func push(_ newController: UIViewController, transitionType type: TransitionType) {
        if type == .flip {
            UIApplication.shared.isStatusBarHidden = true
            UIView.animate(withDuration: 0.75, animations: {
                UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
                self.pushViewController(newController, animated: false)
                UIView.setAnimationTransition(.flipFromLeft, for: self.view, cache: false)
            }, completion: { _ in
                UIApplication.shared.isStatusBarHidden = false
            })
        } else if type == .box {
            guard let currentController = self.viewControllers.last else {
                pushViewController(newController, animated: true)
                return
            }
            
            let animDuration = 0.3
            
            UIView.animate(withDuration: animDuration, animations: {
                currentController.tabBarController?.tabBar.alpha = 0
                
                currentController.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                newController.view.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0)
            }) { (_) in
                UIView.animate(withDuration: animDuration, animations: {
                    currentController.view.layer.transform = CATransform3DMakeTranslation(-UIScreen.main.bounds.width, 0, 0)
                })
                self.pushViewController(newController, animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + animDuration * 2, execute: {
                    UIView.animate(withDuration: animDuration, animations: {
                        newController.view.layer.transform = CATransform3DIdentity
                        newController.view.setNeedsLayout()
                    }, completion: { (_) in
                        currentController.tabBarController?.tabBar.alpha = 1
                        currentController.view.transform = CGAffineTransform.identity
                    })
                })
            }
        } else {
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            var transitionType = convertFromCATransitionType(CATransitionType.fade)
            if type == .moveIn {
                transitionType = convertFromCATransitionType(CATransitionType.moveIn)
            } else if type == .push {
                transitionType = convertFromCATransitionType(CATransitionType.push)
            } else if type == .reveal {
                transitionType = convertFromCATransitionType(CATransitionType.reveal)
            }
            transition.type = convertToCATransitionType(transitionType)
            self.view.layer.add(transition, forKey: nil)
            self.pushViewController(newController, animated: false)
        }
    }
    func pop(transitionType type: TransitionType) {
        if type == .flip {
            UIApplication.shared.isStatusBarHidden = true
            UIView.animate(withDuration: 0.75, animations: {
                UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
                UIView.setAnimationTransition(.flipFromRight, for: self.view, cache: false)
            }, completion: { _ in
                UIApplication.shared.isStatusBarHidden = false
            })
            _ = self.popViewController(animated: false)
        } else if type == .box {
            if viewControllers.count < 2 {
                popToRootViewController(animated: true)
                return
            }
            
            let prevCont = viewControllers[viewControllers.count-2]
            pop(to: prevCont, transitionType: .box)
            
        } else {
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            var transitionType = convertFromCATransitionType(CATransitionType.fade)
            if type == .moveIn {
                transitionType = convertFromCATransitionType(CATransitionType.moveIn)
            } else if type == .push {
                transitionType = convertFromCATransitionType(CATransitionType.push)
            } else if type == .reveal {
                transitionType = convertFromCATransitionType(CATransitionType.reveal)
            }
            transition.type = convertToCATransitionType(transitionType)
            self.view.layer.add(transition, forKey: nil)
            self.popViewController(animated: false)
        }
    }
    func popToRoot(transitionType type: TransitionType) {
        if type == .flip {
            UIApplication.shared.isStatusBarHidden = true
            UIView.animate(withDuration: 0.75, animations: {
                UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
                UIView.setAnimationTransition(.flipFromRight, for: self.view, cache: false)
            }, completion: { _ in
                UIApplication.shared.isStatusBarHidden = false
            })
            self.popToRootViewController(animated: false)
        } else if type == .box {
            guard let firstCont = viewControllers.first else {
                popToRootViewController(animated: true)
                return
            }
            pop(to: firstCont, transitionType: .box)
            
        } else {
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            var transitionType = convertFromCATransitionType(CATransitionType.fade)
            if type == .moveIn {
                transitionType = convertFromCATransitionType(CATransitionType.moveIn)
            } else if type == .push {
                transitionType = convertFromCATransitionType(CATransitionType.push)
            } else if type == .reveal {
                transitionType = convertFromCATransitionType(CATransitionType.reveal)
            }
            transition.type = convertToCATransitionType(transitionType)
            self.view.layer.add(transition, forKey: nil)
            self.popToRootViewController(animated: false)
        }
    }
    func pop(to: UIViewController, transitionType type: TransitionType) {
        if type == .flip {
            UIApplication.shared.isStatusBarHidden = true
            UIView.animate(withDuration: 0.75, animations: {
                UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
                UIView.setAnimationTransition(.flipFromRight, for: self.view, cache: false)
            }, completion: { _ in
                UIApplication.shared.isStatusBarHidden = false
            })
            _ = self.popToViewController(to, animated: false)
        } else if type == .box {
            let animDuration = 0.3
            
            guard let currentController = viewControllers.last else {
                _ = self.popToViewController(to, animated: false)
                return
            }
            
            UIView.animate(withDuration: animDuration, animations: {
                currentController.tabBarController?.tabBar.alpha = 0
                
                currentController.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                to.view.layer.transform = CATransform3DMakeScale(0.45, 0.45, 0.45)
            }) { (_) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + animDuration, execute: {
                    self.popViewController(animated: true)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + animDuration * 2, execute: {
                        UIView.animate(withDuration: animDuration, animations: {
                            to.tabBarController?.tabBar.alpha = 1
                            to.view.layer.transform = CATransform3DIdentity
                            to.view.transform = CGAffineTransform.identity
                            
                            to.view.setNeedsLayout()
                        })
                    })
                })
            }
        } else {
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            var transitionType = convertFromCATransitionType(CATransitionType.fade)
            if type == .moveIn {
                transitionType = convertFromCATransitionType(CATransitionType.moveIn)
            } else if type == .push {
                transitionType = convertFromCATransitionType(CATransitionType.push)
            } else if type == .reveal {
                transitionType = convertFromCATransitionType(CATransitionType.reveal)
            }
            transition.type = convertToCATransitionType(transitionType)
            self.view.layer.add(transition, forKey: nil)
            _ = self.popToViewController(to, animated: false)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATransitionType(_ input: CATransitionType) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCATransitionType(_ input: String) -> CATransitionType {
	return CATransitionType(rawValue: input)
}
